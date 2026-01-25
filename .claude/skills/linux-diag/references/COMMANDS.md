# Linux診断コマンドリファレンス

各カテゴリ別の診断コマンドを段階的に整理したリファレンスです。

---

## CPU負荷

### Level 1: 基本

```bash
# Load Average確認（1分/5分/15分平均）
uptime
# 出力例: load average: 2.50, 1.80, 1.20
# 目安: CPUコア数を超えると高負荷

# CPUコア数確認
nproc
grep -c processor /proc/cpuinfo

# リアルタイムCPU監視
top
htop  # より見やすい（要インストール）

# CPU使用率上位プロセス
ps aux --sort=-%cpu | head -10
```

### Level 2: 詳細

```bash
# CPU統計（1秒間隔で5回）
vmstat 1 5
# 列の意味:
#   r  - 実行待ちプロセス数
#   b  - I/O待ちプロセス数
#   us - ユーザー空間CPU使用率
#   sy - システム空間CPU使用率
#   id - アイドル率
#   wa - I/O待ち率

# mpstat（CPUコア別統計、要 sysstat）
mpstat -P ALL 1 5

# プロセス別CPU使用率（継続監視）
pidstat 1 5
```

### Level 3: 高度

```bash
# 特定プロセスのCPU使用を追跡
strace -c -p <PID>

# CPU性能プロファイリング（要 perf）
perf top
perf record -g -p <PID>
perf report

# CPU使用率の履歴（要 sar/sysstat）
sar -u 1 10
```

---

## メモリ

### Level 1: 基本

```bash
# メモリ使用状況
free -h
# 重要な項目:
#   total     - 総メモリ
#   used      - 使用中
#   free      - 未使用
#   available - 利用可能（バッファ/キャッシュ含む）

# メモリ使用量上位プロセス
ps aux --sort=-%mem | head -10

# OOM Killer発動履歴
dmesg | grep -i "out of memory"
dmesg | grep -i "oom"
```

### Level 2: 詳細

```bash
# 詳細なメモリ情報
cat /proc/meminfo

# スワップ使用状況
swapon --show
cat /proc/swaps

# プロセス別メモリ詳細
pmap -x <PID>

# メモリ統計（vmstat）
vmstat -s

# キャッシュ/バッファ詳細
cat /proc/meminfo | grep -E "^(Buffers|Cached|SwapCached)"
```

### Level 3: 高度

```bash
# プロセスのメモリマップ
cat /proc/<PID>/maps
cat /proc/<PID>/smaps

# メモリリーク検出（要 valgrind）
valgrind --leak-check=full <command>

# システム全体のメモリ使用履歴（要 sar）
sar -r 1 10

# OOM Score確認（OOM Killerの優先度）
cat /proc/<PID>/oom_score
```

---

## ディスク

### Level 1: 基本

```bash
# ファイルシステム使用状況
df -h
df -i  # inode使用状況

# ディレクトリサイズ
du -sh /path/to/dir
du -sh /* | sort -h  # ルート直下のサイズ

# 大きなファイル検索
find / -type f -size +100M 2>/dev/null | head -20
```

### Level 2: 詳細

```bash
# ディスクI/O統計（要 sysstat）
iostat -x 1 5
# 重要な列:
#   %util   - デバイス使用率（100%に近いと飽和）
#   await   - I/O待ち時間(ms)
#   r/s,w/s - 読み書き回数/秒

# ブロックデバイス情報
lsblk
lsblk -f  # ファイルシステム情報付き

# マウント情報
mount | column -t
cat /proc/mounts

# 開いているファイル
lsof +D /path/to/dir
lsof -p <PID>  # 特定プロセス
```

### Level 3: 高度

```bash
# I/O負荷の高いプロセス（要 iotop）
iotop -o

# ディスク性能テスト（注意: 書き込みテスト）
dd if=/dev/zero of=/tmp/test bs=1M count=1024 conv=fdatasync

# ファイルシステムチェック（アンマウント必要）
fsck -n /dev/sdX  # -n は読み取り専用

# SMART情報（ディスク健全性）
smartctl -a /dev/sda

# I/O履歴（要 sar）
sar -d 1 10
```

---

## ネットワーク

### Level 1: 基本

```bash
# IPアドレス確認
ip addr
ip a  # 短縮形

# ルーティングテーブル
ip route
route -n  # 旧形式

# 接続確認
ping -c 4 8.8.8.8        # 外部IP
ping -c 4 google.com      # DNS解決確認

# DNS確認
cat /etc/resolv.conf
nslookup google.com
dig google.com
```

### Level 2: 詳細

```bash
# リスニングポート確認
ss -tlnp          # TCP
ss -ulnp          # UDP
ss -tlnp | grep LISTEN

# 接続状態一覧
ss -tan           # TCP全接続
netstat -an       # 旧形式

# 接続数カウント（状態別）
ss -tan | awk '{print $1}' | sort | uniq -c

# ネットワーク統計
ip -s link        # インターフェース統計
cat /proc/net/dev

# ポート到達確認
nc -zv hostname 80
telnet hostname 80
```

### Level 3: 高度

```bash
# パケットキャプチャ（要 sudo）
tcpdump -i eth0 -n port 80
tcpdump -i any -w capture.pcap

# トレースルート
traceroute google.com
mtr google.com  # 継続的トレース

# ネットワーク帯域監視（要 iftop）
iftop -i eth0

# ソケット統計
ss -s

# netfilter/iptables確認
iptables -L -n -v
nft list ruleset  # nftables
```

---

## プロセス

### Level 1: 基本

```bash
# 全プロセス一覧
ps aux
ps -ef

# プロセスツリー
pstree
pstree -p  # PID付き

# 特定プロセス検索
ps aux | grep nginx
pgrep -a nginx
pidof nginx

# ゾンビプロセス検索
ps aux | awk '$8=="Z"'
```

### Level 2: 詳細

```bash
# プロセス詳細情報
cat /proc/<PID>/status
cat /proc/<PID>/cmdline

# プロセスが開いているファイル
lsof -p <PID>

# プロセスのファイルディスクリプタ
ls -la /proc/<PID>/fd

# プロセスのリソース使用量
cat /proc/<PID>/stat
cat /proc/<PID>/io  # I/O統計

# スレッド一覧
ps -T -p <PID>
```

### Level 3: 高度

```bash
# システムコールトレース（要 sudo）
strace -p <PID>
strace -f -e trace=network -p <PID>  # ネットワーク系のみ

# ライブラリコールトレース
ltrace -p <PID>

# プロセスのシグナル送信
kill -l              # シグナル一覧
kill -SIGTERM <PID>  # 正常終了要求
kill -SIGKILL <PID>  # 強制終了

# cgroup情報（コンテナ環境）
cat /proc/<PID>/cgroup
```

---

## サービス

### Level 1: 基本（systemd環境）

```bash
# サービス状態確認
systemctl status nginx
systemctl is-active nginx
systemctl is-enabled nginx

# サービス一覧
systemctl list-units --type=service
systemctl list-units --state=failed

# サービス操作
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl reload nginx
```

### Level 2: 詳細

```bash
# サービスの依存関係
systemctl list-dependencies nginx
systemctl list-dependencies --reverse nginx

# サービスのログ
journalctl -u nginx
journalctl -u nginx -f  # フォロー
journalctl -u nginx --since "1 hour ago"

# ユニットファイル確認
systemctl cat nginx
systemctl show nginx

# 起動時間分析
systemd-analyze
systemd-analyze blame
```

### Level 3: 高度

```bash
# サービスのリソース制限確認
systemctl show nginx | grep -E "^(Memory|CPU|Tasks)"

# ユニットファイル編集（オーバーライド）
systemctl edit nginx

# サービスマスク（起動不可に）
systemctl mask nginx
systemctl unmask nginx

# journal詳細分析
journalctl -u nginx -p err  # エラーのみ
journalctl --disk-usage
journalctl --vacuum-size=500M
```

### SysVinit環境（旧形式）

```bash
# サービス操作
service nginx status
service nginx start
service nginx stop

# 自動起動設定
chkconfig --list
chkconfig nginx on
update-rc.d nginx defaults  # Debian系
```

---

## ログ

### Level 1: 基本

```bash
# システムログ（systemd環境）
journalctl
journalctl -xe    # 最新ログ（詳細）
journalctl -f     # リアルタイム

# 従来のログファイル
tail -f /var/log/syslog       # Debian/Ubuntu
tail -f /var/log/messages     # RHEL/CentOS

# 認証ログ
tail -100 /var/log/auth.log   # Debian/Ubuntu
tail -100 /var/log/secure     # RHEL/CentOS
```

### Level 2: 詳細

```bash
# journal フィルタリング
journalctl --since "2024-01-01 00:00:00"
journalctl --since "1 hour ago"
journalctl -p err             # エラー以上
journalctl -p warning         # 警告以上
journalctl -k                 # カーネルメッセージのみ

# 特定ユニットのログ
journalctl -u nginx -u php-fpm

# カーネルメッセージ
dmesg
dmesg -T  # タイムスタンプ付き
dmesg | tail -50

# ログローテーション状態
cat /etc/logrotate.conf
ls -la /var/log/*.gz
```

### Level 3: 高度

```bash
# journal出力形式
journalctl -o json-pretty     # JSON形式
journalctl -o verbose         # 全フィールド

# 特定プロセスのログ
journalctl _PID=<PID>
journalctl _COMM=nginx

# ブート別ログ
journalctl --list-boots
journalctl -b -1  # 前回ブート

# 監査ログ（要 auditd）
ausearch -m LOGIN
aureport --summary
```

---

## その他有用コマンド

### システム情報

```bash
# OS情報
cat /etc/os-release
uname -a
hostnamectl

# ハードウェア情報
lscpu
lsmem
lspci
lsusb

# 稼働時間
uptime
who -b  # 最終起動時刻
```

### パフォーマンス総合

```bash
# 包括的システム監視（要 dstat）
dstat -cdngy

# システム全体サマリ（要 glances）
glances

# 負荷発生源の特定
atop  # 要インストール
```

---

## コマンド早見表

| 症状 | 最初に実行 | 詳細調査 |
|------|-----------|---------|
| システムが遅い | `uptime`, `top` | `vmstat 1 5`, `iostat -x 1 5` |
| メモリ不足 | `free -h` | `ps aux --sort=-%mem`, `dmesg \| grep oom` |
| ディスク満杯 | `df -h` | `du -sh /*`, `find / -size +100M` |
| ネット接続不可 | `ip addr`, `ping` | `ss -tlnp`, `tcpdump` |
| サービス停止 | `systemctl status` | `journalctl -u <service>` |
| 原因不明エラー | `dmesg \| tail` | `journalctl -p err` |
| GPU問題 | `nvidia-smi` | `nvidia-smi -q`, `dmesg \| grep nvidia` |
| xrdp黒画面 | `systemctl status xrdp` | `journalctl -u xrdp`, `~/.xorgxrdp.*.log` |
| コンテナ内GPU不可 | `docker exec <c> nvidia-smi` | `docker inspect`, Persistence Mode確認 |
| デバイス権限拒否 | `groups`, `ls -la /dev/dri/` | `getfacl`, `id` |

---

## GPU/NVIDIA

### Level 1: 基本

```bash
# GPU状態確認（最も重要）
nvidia-smi
# 出力例:
# +---------------------------------------------------------------------------------------+
# | NVIDIA-SMI 535.274.02    Driver Version: 535.274.02   CUDA Version: 12.2     |
# | GPU Name        Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
# +---------------------------------------------------------------------------------------+

# ドライバーバージョン確認
cat /proc/driver/nvidia/version

# NVIDIAカーネルモジュール確認
lsmod | grep nvidia

# CUDAバージョン確認
nvcc --version  # CUDA toolkit インストール時
```

### Level 2: 詳細

```bash
# GPU詳細情報
nvidia-smi -q
nvidia-smi -q | head -50

# Persistence Mode確認（重要！）
nvidia-smi -q | grep "Persistence Mode"
# Disabled → GPUがスリープする可能性あり（問題の原因になりやすい）
# Enabled → 常時稼働（推奨）

# Persistence Mode有効化
sudo nvidia-smi -pm 1

# GPU使用状況のリアルタイム監視
nvidia-smi -l 1  # 1秒間隔で更新
watch -n 1 nvidia-smi

# GPUプロセス確認
nvidia-smi --query-compute-apps=pid,process_name,used_memory --format=csv

# nvidia-persistencedサービス確認
systemctl status nvidia-persistenced
```

### Level 3: 高度

```bash
# NVMLライブラリ初期化テスト（Python）
python3 -c "import pynvml; pynvml.nvmlInit(); print('NVML OK')"

# NVEncサポート確認
nvidia-smi --query-gpu=encoder.stats.sessionCount,encoder.stats.averageFps --format=csv

# GPUエラーログ
dmesg | grep -i nvidia
journalctl -k | grep -i nvidia
journalctl -k | grep -i "GPU\|NVRM"

# GPU温度・電力詳細
nvidia-smi --query-gpu=temperature.gpu,power.draw,power.limit --format=csv

# ECC（Error Correcting Code）状態
nvidia-smi --query-gpu=ecc.mode.current,ecc.errors.corrected.volatile.total --format=csv

# GPUリセット（最終手段、要注意）
sudo nvidia-smi --gpu-reset -i 0
```

### nvidia-persistenced設定

```bash
# サービス設定の上書き（Persistence Mode有効化）
sudo systemctl edit nvidia-persistenced.service

# 以下を追加:
# [Service]
# ExecStart=
# ExecStart=/usr/bin/nvidia-persistenced --user nvidia-persistenced --persistence-mode --verbose

# 設定反映
sudo systemctl daemon-reload
sudo systemctl restart nvidia-persistenced
```

---

## グラフィック/ディスプレイ

### Level 1: 基本

```bash
# DRMデバイス確認
ls -la /dev/dri/
# 期待する出力:
# crw-rw---- 1 root video ... card0
# crw-rw---- 1 root render ... renderD128

# ユーザーのグループ確認（videoグループが重要）
groups
groups $(whoami) | grep video

# Xorgディスプレイ確認
echo $DISPLAY
DISPLAY=:0 xrandr  # ディスプレイ情報

# xrdpサービス確認
systemctl status xrdp
systemctl status xrdp-sesman
```

### Level 2: 詳細

```bash
# DRMデバイスのACL確認
getfacl /dev/dri/card0
getfacl /dev/dri/renderD128

# xrdpログ確認
journalctl -u xrdp -n 50 --no-pager
journalctl -u xrdp-sesman -n 50 --no-pager

# Xorgログ確認（xrdpセッション）
ls -la ~/.xorgxrdp.*.log
tail -100 ~/.xorgxrdp.*.log | grep -E "EE|WW"  # エラー・警告のみ

# セッションエラー確認
cat ~/.xsession-errors | tail -50

# アクティブなセッション確認
loginctl list-sessions
loginctl show-session <SESSION_ID>

# グラフィックドライバ確認
lspci -k | grep -A 3 VGA
```

### Level 3: 高度

```bash
# DRMデバイス権限の手動設定
sudo setfacl -m u:$USER:rw /dev/dri/card0
sudo setfacl -m u:$USER:rw /dev/dri/renderD128

# videoグループへのユーザー追加
sudo usermod -aG video $USER
# ※ 反映にはログアウト/ログインまたは再起動が必要

# udevルール追加（永続化）
sudo tee /etc/udev/rules.d/99-drm.rules <<EOF
KERNEL=="card[0-9]*", SUBSYSTEM=="drm", MODE="0660", GROUP="video"
KERNEL=="renderD[0-9]*", SUBSYSTEM=="drm", MODE="0660", GROUP="video"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger

# xrdp設定ファイル確認
cat /etc/xrdp/xrdp.ini | head -30
cat /etc/xrdp/sesman.ini | head -30
cat /etc/xrdp/gfx.toml  # グラフィックコーデック設定

# ソフトウェアレンダリング強制（xrdp互換性向上）
# ~/.xsession に追加:
# export LIBGL_ALWAYS_SOFTWARE=1
# export GALLIUM_DRIVER=llvmpipe
# export MUTTER_DEBUG_FORCE_KMS_MODE=simple
```

### xrdp黒画面問題のチェックリスト

```bash
# 1. サービス状態
systemctl is-active xrdp xrdp-sesman

# 2. videoグループ
groups | grep -q video && echo "OK" || echo "NG: videoグループ不足"

# 3. DRMデバイスアクセス
[ -r /dev/dri/card0 ] && echo "OK" || echo "NG: card0読み取り不可"

# 4. Xorgログのエラー
grep -E "EE.*systemd-logind" ~/.xorgxrdp.*.log && echo "権限エラーあり"

# 5. ソフトウェアレンダリング設定
grep -E "LIBGL|GALLIUM" ~/.xsession && echo "設定あり" || echo "設定なし"
```

---

## Docker/コンテナ

### Level 1: 基本

```bash
# コンテナ一覧
docker ps
docker ps -a  # 停止中含む

# コンテナログ確認
docker logs <container_name>
docker logs -f <container_name>  # フォロー
docker logs --tail 100 <container_name>  # 最新100行

# コンテナ内でコマンド実行
docker exec -it <container_name> bash
docker exec <container_name> nvidia-smi  # GPU確認
```

### Level 2: 詳細

```bash
# コンテナ詳細情報
docker inspect <container_name>

# GPU設定確認（DeviceRequests）
docker inspect <container_name> | jq '.[0].HostConfig.DeviceRequests'

# コンテナのリソース使用状況
docker stats <container_name>

# コンテナ内のプロセス
docker top <container_name>

# コンテナのマウント確認
docker inspect <container_name> | jq '.[0].Mounts'

# コンテナのネットワーク確認
docker inspect <container_name> | jq '.[0].NetworkSettings'

# nvidia-container-toolkit確認
dpkg -l | grep nvidia-container
nvidia-container-cli info
```

### Level 3: 高度

```bash
# コンテナ内からのデバイスアクセステスト
docker exec <container_name> ls -la /dev/dri/
docker exec <container_name> cat /proc/driver/nvidia/version

# Docker GPU設定のトラブルシューティング
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

# Dockerデーモンログ
journalctl -u docker -n 50 --no-pager

# nvidia-container-runtime確認
cat /etc/docker/daemon.json | jq .

# コンテナ再作成（設定変更後）
docker compose down
docker compose up -d

# コンテナ内NVMLエラー時の確認
# "Failed to initialize NVML: Unknown Error" → Persistence Mode確認
nvidia-smi -q | grep "Persistence Mode"

# Docker composeでのGPU設定例
# deploy:
#   resources:
#     reservations:
#       devices:
#         - driver: nvidia
#           count: all
#           capabilities: [gpu, compute, utility, video]
```

### コンテナ内GPU問題のチェックリスト

```bash
# 1. ホスト側でnvidia-smi動作確認
nvidia-smi

# 2. Persistence Mode確認
nvidia-smi -q | grep "Persistence Mode"
# Disabled → 問題の原因！ sudo nvidia-smi -pm 1 で有効化

# 3. コンテナ内でnvidia-smi
docker exec <container_name> nvidia-smi
# "Failed to initialize NVML" → Persistence Mode無効が原因の可能性大

# 4. nvidia-container-toolkit確認
nvidia-container-cli info

# 5. Dockerデーモン設定
cat /etc/docker/daemon.json
```

---

## ユーザー権限/ACL

### Level 1: 基本

```bash
# 現在のユーザー情報
whoami
id
id <username>

# 所属グループ確認
groups
groups <username>

# 重要なグループ
# - video: GPU/DRMデバイスアクセス
# - docker: Dockerコマンド実行
# - sudo: 管理者権限
# - audio: オーディオデバイス

# ファイル/ディレクトリ権限確認
ls -la /path/to/file
stat /path/to/file
```

### Level 2: 詳細

```bash
# グループへのユーザー追加
sudo usermod -aG video $USER
sudo usermod -aG docker $USER
# ※ 反映にはログアウト/ログインまたは再起動が必要

# ACL（アクセス制御リスト）確認
getfacl /dev/dri/card0
getfacl /path/to/file

# ACL設定
sudo setfacl -m u:username:rw /path/to/file
sudo setfacl -m g:groupname:rx /path/to/dir

# ACL削除
sudo setfacl -x u:username /path/to/file
sudo setfacl -b /path/to/file  # 全ACL削除

# sudoers確認
sudo cat /etc/sudoers
sudo cat /etc/sudoers.d/*

# PAM設定確認
cat /etc/pam.d/common-auth
cat /etc/pam.d/xrdp-sesman
```

### Level 3: 高度

```bash
# udevルールでデバイス権限を永続化
sudo tee /etc/udev/rules.d/99-custom.rules <<EOF
# DRMデバイス（GPU）
KERNEL=="card[0-9]*", SUBSYSTEM=="drm", MODE="0660", GROUP="video"
KERNEL=="renderD[0-9]*", SUBSYSTEM=="drm", MODE="0660", GROUP="video"
EOF

# udevルール反映
sudo udevadm control --reload-rules
sudo udevadm trigger

# capabilities確認（セキュリティ）
getcap /path/to/binary
# 例: getcap /usr/bin/ping

# SELinux/AppArmor確認
getenforce  # SELinux
aa-status   # AppArmor

# ログイン時のグループ反映確認
loginctl show-user $USER | grep Linger
```

### 権限問題のチェックリスト

```bash
# 1. ユーザーID・グループ確認
id

# 2. 必要なグループに所属しているか
groups | grep -E "video|docker|audio"

# 3. デバイスファイルの権限確認
ls -la /dev/dri/
ls -la /dev/snd/

# 4. ACL確認
getfacl /dev/dri/card0

# 5. dmesgで権限エラー確認
dmesg | grep -i "permission\|denied\|access"
```
