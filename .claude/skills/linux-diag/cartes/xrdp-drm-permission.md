# xrdp接続時の黒画面問題（DRM権限）

**タグ**: xrdp, DRM, video, 権限, 黒画面
**日時**: 2025-11-25
**環境**: Ubuntu 24.04, GNOME Shell

---

## 症状

- apt upgrade後にxrdpでのリモートデスクトップ接続ができなくなった
- 認証は成功するが、画面が真っ暗で何も表示されない
- 接続直後に自動切断される

## 調査プロセス

### Step 1: サービス状態確認

```bash
$ systemctl status xrdp
● xrdp.service - xrdp daemon
   Active: active (running)

$ systemctl status xrdp-sesman
● xrdp-sesman.service - xrdp session manager
   Active: active (running)
```

→ サービスは正常稼働

### Step 2: ログ確認

```bash
$ journalctl -u xrdp -n 20 --no-pager
[ERROR] Xorg server closed connection

$ tail -100 ~/.xorgxrdp.*.log | grep -E "EE|WW"
(EE) systemd-logind: failed to take device /dev/dri/card0: Operation not permitted
```

→ **DRMデバイスへのアクセス権限エラー**を発見

### Step 3: ユーザーグループ確認

```bash
$ groups
s4kr4 : s4kr4 adm cdrom sudo audio dip plugdev users lpadmin docker sambashare

$ groups | grep video
（出力なし）
```

→ **videoグループに所属していない**ことが判明

### Step 4: DRMデバイス権限確認

```bash
$ ls -la /dev/dri/
crw-rw---- 1 root video 226, 0 Nov 25 10:00 card0
crw-rw---- 1 root render 226, 128 Nov 25 10:00 renderD128

$ getfacl /dev/dri/card0
# file: dev/dri/card0
# owner: root
# group: video
user::rw-
user:gdm:rw-
group::rw-
```

→ videoグループに所属していないためアクセス不可

## 根本原因

- `systemd-logind` のDRMデバイスアクセス権限管理が厳格化された
- ユーザーが `video` グループに所属していないため `/dev/dri/card0` にアクセスできない
- Xorgサーバーが接続直後に終了していた

## 解決策

```bash
# videoグループにユーザーを追加
sudo usermod -aG video $USER

# システム再起動（グループ変更を反映）
sudo reboot

# 再起動後、グループ確認
groups | grep video
# 出力: ... video ...  ← 追加されていればOK
```

## 学んだこと

1. Ubuntu 24.04ではsystemd-logindのDRMデバイス管理が厳格化された
2. xrdpユーザーは`video`グループに所属する必要がある
3. トラブルシューティング順序: サービスログ → Xorgログ → デバイス権限
