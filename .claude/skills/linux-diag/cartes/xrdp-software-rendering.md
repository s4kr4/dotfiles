# xrdp接続時の黒画面問題（ソフトウェアレンダリング）

**タグ**: xrdp, GNOME, レンダリング, 黒画面, Mutter
**日時**: 2025-12-15
**環境**: Ubuntu 24.04, GNOME Shell, NVIDIA GPU

---

## 症状

- videoグループには所属済み（前回の問題は解決済み）
- 認証は成功、Xorgサーバーも起動
- しかし画面が真っ暗で、3秒程度で自動切断される

## 調査プロセス

### Step 1: 前回との差分確認

```bash
$ groups | grep video
... video ...  # OK

$ getfacl /dev/dri/card0 | grep $USER
# アクセス権あり
```

→ 前回の問題（DRM権限）は解決済み

### Step 2: xrdpログ詳細確認

```bash
$ journalctl -u xrdp -n 30 --no-pager
[INFO] login was successful - creating session
[INFO] connected to Xorg_pid=4225
[ERROR] xrdp_sec_recv: xrdp_mcs_recv failed
```

→ ログイン成功、Xorg接続成功、しかし**3秒後にクライアント側から切断**

### Step 3: GNOME Shellプロセス確認

```bash
$ ps aux | grep gnome-shell
s4kr4 4300 ... gnome-shell --display-server
```

→ GNOME Shellは起動している

### Step 4: グラフィックコーデック確認

```bash
$ cat /etc/xrdp/gfx.toml | head -5
[codec]
order = [ "H.264", "RFX" ]
```

→ H.264コーデックが優先されている

## 根本原因

- GNOME ShellがハードウェアアクセラレーションをGPU経由で使用しようとして失敗
- xrdp環境では物理GPUへの直接アクセスが制限される
- GNOME Shellがハードウェアレンダリング（OpenGL/GPU）を試みるが、適切なGPUコンテキストが得られない
- 結果として画面が描画されず、クライアント側は真っ暗のまま

## 解決策

### 1. グラフィックコーデック変更

```bash
# RFXを優先（H.264より互換性が高い）
sudo sed -i 's/order = \[ "H.264", "RFX" \]/order = [ "RFX" ]/' /etc/xrdp/gfx.toml
```

### 2. ソフトウェアレンダリング強制（最重要）

`~/.xsession` に以下を追加:

```bash
# ソフトウェアレンダリングを強制（xrdp互換性向上）
export MUTTER_DEBUG_FORCE_KMS_MODE=simple
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
```

| 環境変数 | 役割 |
|---------|------|
| `MUTTER_DEBUG_FORCE_KMS_MODE=simple` | MutterにシンプルなKMSモードを使用させる |
| `LIBGL_ALWAYS_SOFTWARE=1` | OpenGLをソフトウェアレンダリングで強制 |
| `GALLIUM_DRIVER=llvmpipe` | CPUベースのソフトウェアレンダラーを使用 |

### 3. サービス再起動

```bash
sudo systemctl restart xrdp xrdp-sesman
pkill -u $USER gnome-session  # 既存セッション終了
```

## 学んだこと

1. GNOME Shellはxrdp環境で特別な設定が必要
2. デフォルトではハードウェアアクセラレーションを要求するため、ソフトウェアレンダリングの明示的な設定が必須
3. H.264よりRFX (RemoteFX)の方がWindows標準クライアントとの互換性が高い
