# Dockerコンテナ内でGPUアクセス不可（Persistence Mode）

**タグ**: Docker, GPU, NVIDIA, Persistence Mode, NVML, コンテナ
**日時**: 2025-12-31
**環境**: Ubuntu, NVIDIA GeForce GTX 1080 Ti, Docker + nvidia-container-toolkit

---

## 症状

- Dockerコンテナ（KonomiTV）起動直後は正常動作
- 時間経過後（数時間〜数日）に突然エラー発生
- エラー: `チューナーとの接続が切断されました。エンコードタスクを再起動しています…`
- コンテナ再起動で一時的に復旧するが、再発する

## 調査プロセス

### Step 1: コンテナログ確認

```bash
$ docker logs KonomiTV --tail 50
[INFO] Acquired a tuner from Mirakurun.
[INFO] Tuner: PX-W3PE4-T2 / Type: GR) / Acquired in 0.49 seconds
[INFO] [Live: gr041-1080p] [Status: Standby] チューナーを起動しています…
[INFO] [Live: gr041-1080p] [Status: Restart] チューナーとの接続が切断されました。エンコードタスクを再起動しています… (ER-05)
```

→ チューナー取得は成功、しかし**即座にエンコードタスクが失敗**

### Step 2: コンテナ内でnvidia-smi実行

```bash
$ docker exec KonomiTV nvidia-smi
Failed to initialize NVML: Unknown Error
```

→ **コンテナ内からNVML（NVIDIA Management Library）にアクセスできない！**

### Step 3: ホスト側でnvidia-smi確認

```bash
$ nvidia-smi
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 535.274.02    Driver Version: 535.274.02   CUDA Version: 12.2    |
|   0  NVIDIA GeForce GTX 1080 Ti     Off | 00000000:01:00.0 Off |        N/A |
|  0%   32C    P8              10W / 280W |     20MiB / 11264MiB |   0%      |
+-----------------------------------------------------------------------------+
```

→ ホスト側では正常動作

### Step 4: Persistence Mode確認

```bash
$ nvidia-smi -q | grep "Persistence Mode"
    Persistence Mode                      : Disabled
```

→ **Persistence Modeが無効！**

### Step 5: nvidia-persistencedサービス確認

```bash
$ systemctl status nvidia-persistenced
● nvidia-persistenced.service - NVIDIA Persistence Daemon
   Active: active (running)

起動コマンド:
/usr/bin/nvidia-persistenced --user nvidia-persistenced --no-persistence-mode --verbose
                                                        ^^^^^^^^^^^^^^^^^^^^^^^^
```

→ `--no-persistence-mode` フラグで実行されている

## 根本原因

**GPU Persistence Modeが無効であることが原因**

1. コンテナ起動直後はGPUドライバが稼働中
2. しばらくするとGPUがアイドル状態になる
3. Persistence Modeが無効なため、ドライバが休止/アンロードされる
4. KonomiTVがNVEncC（ハードウェアエンコーダ）を起動しようとする
5. GPUドライバが休止状態のため、**NVML初期化に失敗**
6. NVEncCが起動できず、エンコードタスクが即座に終了
7. KonomiTVが「チューナー接続切断」と誤認識（実際はエンコーダー起動失敗）

## 解決策

### 1. Persistence Modeを即座に有効化

```bash
sudo nvidia-smi -pm 1

# 確認
nvidia-smi -q | grep "Persistence Mode"
# Persistence Mode : Enabled
```

### 2. systemdサービス設定を永続化

```bash
sudo systemctl edit nvidia-persistenced.service

# 以下を追加:
[Service]
ExecStart=
ExecStart=/usr/bin/nvidia-persistenced --user nvidia-persistenced --persistence-mode --verbose

# 反映
sudo systemctl daemon-reload
sudo systemctl restart nvidia-persistenced
```

### 3. 起動時自動有効化サービス追加（より確実）

```bash
sudo tee /etc/systemd/system/nvidia-persistence-mode.service > /dev/null <<'EOF'
[Unit]
Description=NVIDIA Persistence Mode
After=nvidia-persistenced.service
Requires=nvidia-persistenced.service

[Service]
Type=oneshot
ExecStart=/usr/bin/nvidia-smi -pm 1
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable nvidia-persistence-mode.service
sudo systemctl start nvidia-persistence-mode.service
```

### 4. コンテナ再起動・確認

```bash
docker restart KonomiTV

# 確認
docker exec KonomiTV nvidia-smi
# 正常な出力が得られればOK
```

## 学んだこと

1. **Persistence Modeの重要性**: 無効だとGPUドライバが休止し、コンテナからアクセスできなくなる
2. **エラーメッセージの罠**: 「チューナー接続切断」と表示されても、実際はエンコーダー（GPU）の問題の可能性がある
3. **再起動で一時的に直る場合**: ドライバやハードウェアの状態変化を疑う
4. **ログの読み方**: 複数のログ（アプリ、Docker、カーネル）を横断的に確認する
