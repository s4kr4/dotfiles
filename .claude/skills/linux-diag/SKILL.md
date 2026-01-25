---
name: linux-diag
description: Linux系OSのシステム不具合診断スキル。システムが遅い、応答しない、エラーが発生する等の問題調査時に使用。CPU、メモリ、ディスク、ネットワーク、プロセス、サービス、ログ、GPU/NVIDIA、グラフィック/xrdp、Docker/コンテナの診断コマンドとフローチャートを提供。
---

# Linux System Diagnostics Skill

Linux系OSのシステム不具合を調査・診断するための知識ベースです。

## 概要

このスキルは以下の状況で自動的に参照されます：

- システムが遅い・重い
- サーバーが応答しない
- プロセスがハングしている
- ディスク容量やI/O問題
- ネットワーク接続問題
- サービスが起動しない
- 原因不明のエラー
- GPU/NVIDIAの問題（nvidia-smi失敗、CUDA/NVEncエラー）
- グラフィック/ディスプレイ問題（xrdp黒画面、DRM権限エラー）
- Docker/コンテナの問題（コンテナ内からデバイスアクセス不可）
- ユーザー権限/グループの問題（デバイスアクセス拒否）

## 診断カテゴリ

| カテゴリ | 主な症状 | 詳細 |
|---------|---------|------|
| CPU | 高負荷、遅延 | [COMMANDS.md#cpu](references/COMMANDS.md#cpu負荷) |
| メモリ | OOM、スワップ | [COMMANDS.md#memory](references/COMMANDS.md#メモリ) |
| ディスク | 容量不足、I/O遅延 | [COMMANDS.md#disk](references/COMMANDS.md#ディスク) |
| ネットワーク | 接続失敗、遅延 | [COMMANDS.md#network](references/COMMANDS.md#ネットワーク) |
| プロセス | ハング、ゾンビ | [COMMANDS.md#process](references/COMMANDS.md#プロセス) |
| サービス | 起動失敗 | [COMMANDS.md#service](references/COMMANDS.md#サービス) |
| ログ | エラー調査 | [COMMANDS.md#log](references/COMMANDS.md#ログ) |
| GPU/NVIDIA | nvidia-smi失敗、CUDA/NVEncエラー | [COMMANDS.md#gpu](references/COMMANDS.md#gpunvidia) |
| グラフィック | xrdp黒画面、DRM権限エラー | [COMMANDS.md#graphics](references/COMMANDS.md#グラフィックディスプレイ) |
| Docker/コンテナ | コンテナ内デバイスアクセス不可 | [COMMANDS.md#docker](references/COMMANDS.md#dockerコンテナ) |
| 権限/ACL | デバイスアクセス拒否、グループ不足 | [COMMANDS.md#permission](references/COMMANDS.md#ユーザー権限acl) |

## クイックスタート: 初動診断

問題の切り分けのため、まず以下を実行：

```bash
# 1. システム全体の状態確認
uptime                    # 負荷平均確認
free -h                   # メモリ使用状況
df -h                     # ディスク使用状況

# 2. リソース消費トップ確認
top -bn1 | head -20       # CPU/メモリ上位プロセス

# 3. 最近のエラー確認
dmesg | tail -30          # カーネルメッセージ
journalctl -p err -n 20   # エラーログ（systemd環境）
```

## 診断フローチャート

詳細な診断手順は [FLOWCHART.md](references/FLOWCHART.md) を参照。

### 簡易フロー

```
問題発生
    │
    ├─→ システムが遅い
    │       ├─ uptime で Load Average 確認
    │       ├─ 高い → CPU負荷診断へ
    │       └─ 低い → I/O待ち診断へ
    │
    ├─→ メモリ不足エラー
    │       ├─ free -h で確認
    │       ├─ dmesg | grep -i oom
    │       └─ メモリ診断へ
    │
    ├─→ ディスク関連エラー
    │       ├─ df -h で容量確認
    │       ├─ iostat でI/O確認
    │       └─ ディスク診断へ
    │
    ├─→ ネットワーク接続問題
    │       ├─ ip addr / ping で基本確認
    │       ├─ ss -tlnp でポート確認
    │       └─ ネットワーク診断へ
    │
    ├─→ サービス起動失敗
    │       ├─ systemctl status <service>
    │       ├─ journalctl -u <service>
    │       └─ サービス診断へ
    │
    ├─→ GPU/NVIDIA問題
    │       ├─ nvidia-smi で状態確認
    │       ├─ nvidia-smi -q | grep "Persistence Mode"
    │       └─ GPU診断へ
    │
    ├─→ グラフィック/xrdp問題
    │       ├─ ls -la /dev/dri/ でデバイス確認
    │       ├─ groups | grep video
    │       └─ グラフィック診断へ
    │
    └─→ コンテナ内デバイス問題
            ├─ docker exec <container> nvidia-smi
            ├─ docker inspect でDeviceRequests確認
            └─ コンテナ診断へ
```

## コマンドリファレンス

詳細なコマンドリスト: [COMMANDS.md](references/COMMANDS.md)

### 必須コマンド（覚えておくべき基本）

| 目的 | コマンド | 説明 |
|------|---------|------|
| 負荷確認 | `uptime` | Load Average（1/5/15分） |
| メモリ | `free -h` | メモリ使用状況 |
| ディスク容量 | `df -h` | ファイルシステム使用状況 |
| プロセス | `ps aux` | 全プロセス一覧 |
| リアルタイム監視 | `top` / `htop` | CPU/メモリ監視 |
| ネットワーク | `ip addr` | IPアドレス確認 |
| ポート | `ss -tlnp` | リスニングポート |
| ログ | `journalctl -xe` | 最新ログ（詳細） |

## 診断レベル

### Level 1: 基本診断（初心者向け）

- `uptime`, `free`, `df`, `top`, `ps`
- 問題の大まかな切り分け

### Level 2: 詳細診断（中級者向け）

- `vmstat`, `iostat`, `netstat`/`ss`, `lsof`
- 原因の特定

### Level 3: 高度診断（上級者向け）

- `strace`, `perf`, `tcpdump`, `/proc` 解析
- 根本原因の究明

## 注意事項

- `sudo` が必要なコマンドあり（一部プロセス情報、tcpdump等）
- 本番環境での `strace`, `tcpdump` は慎重に（パフォーマンス影響）
- ログファイルのパスはディストリビューションで異なる場合あり

## 関連ファイル

- [COMMANDS.md](references/COMMANDS.md) - コマンド詳細リファレンス
- [FLOWCHART.md](references/FLOWCHART.md) - 診断フローチャート

## 調査カルテ（cartes/）

過去の調査事例を個別ファイルで管理。症状に応じて関連カルテを検索して参照。

```bash
# カルテ一覧
ls cartes/

# キーワードでカルテを検索
grep -l "xrdp" cartes/*.md
grep -l "GPU" cartes/*.md
grep -l "Docker" cartes/*.md
```

| カルテ | タグ |
|-------|------|
| xrdp-drm-permission.md | xrdp, DRM, video, 権限 |
| xrdp-software-rendering.md | xrdp, GNOME, レンダリング, Mutter |
| docker-gpu-persistence.md | Docker, GPU, NVIDIA, Persistence Mode |
