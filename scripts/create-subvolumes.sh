#!/usr/bin/env bash
# 「新建 volume 阶段」：按 disko.nix 的声明创建 + 挂载 btrfs subvolume。
#
# 对应 modules/hosts/a99r50/disko.nix 里的 disko.devices.disk.main...subvolumes 清单。
# disko 只在格式化阶段建子卷，运行中的系统补建/重建子卷用这个脚本。
# 幂等：子卷已存在、挂载点已挂载都会被跳过，可随时重复执行。
#
# 用法:
#   sudo bash scripts/create-subvolumes.sh            # 处理清单里全部条目
#   sudo bash scripts/create-subvolumes.sh docker     # 只处理指定名字
#   DRY_RUN=1 bash scripts/create-subvolumes.sh       # 只打印会做什么，不动盘（不需要 root）
#
# 可覆盖的环境变量:
#   TOP=/partition-root   DEV=/dev/disk/by-partlabel/disk-main-root
set -euo pipefail

# btrfs 顶层 subvol (subvolid=5) 的挂载点，disko.nix 里写成 /partition-root
TOP="${TOP:-/partition-root}"
# 数据分区：a99r50 的 disk-main-root -> nvme0n1p3（用 partlabel，与 fstab 保持一致）
DEV="${DEV:-/dev/disk/by-partlabel/disk-main-root}"
DRY_RUN="${DRY_RUN:-0}"

# 清单 name:mountpoint:mountOptions（options 里不要写 subvol=）
#   docker -> 不压缩 + 关闭 CoW，且独立于 @root，不会被开机回滚清空
SUBVOLS=(
  "docker:/var/lib/docker:noatime,nodatacow"
)

want=("$@")
selected() {
  if [ "${#want[@]}" -eq 0 ]; then return 0; fi
  local n
  for n in "${want[@]}"; do
    if [ "$n" = "$1" ]; then return 0; fi
  done
  return 1
}

# 需要权限的写操作统一走 run，dry-run 时只打印
run() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "    [dry-run] $*"
    return 0
  fi
  "$@"
}

if [ "$DRY_RUN" = 1 ]; then
  echo "*** DRY-RUN：只打印将要执行的操作 ***"
else
  [ "$(id -u)" -eq 0 ] || { echo "请用 sudo 运行" >&2; exit 1; }
fi
[ -e "$DEV" ] || { echo "找不到设备 $DEV" >&2; exit 1; }

if ! mountpoint -q "$TOP"; then
  echo ">>> btrfs 顶层未挂载，先挂到 $TOP"
  run mkdir -p "$TOP"
  run mount -t btrfs "$DEV" "$TOP"
fi

for entry in "${SUBVOLS[@]}"; do
  name="${entry%%:*}"
  rest="${entry#*:}"
  mnt="${rest%%:*}"
  opts="${rest#*:}"
  selected "$name" || continue

  echo ">>> [$name] $TOP/$name -> $mnt"
  if btrfs subvolume show "$TOP/$name" >/dev/null 2>&1; then
    echo "    子卷已存在，跳过创建"
  else
    if [ "$DRY_RUN" = 1 ] && [ "$(id -u)" -ne 0 ]; then
      echo "    (非 root 查不到子卷状态，下面按「需要创建」推演)"
    fi
    run btrfs subvolume create "$TOP/$name"
  fi

  run mkdir -p "$mnt"
  if mountpoint -q "$mnt"; then
    echo "    已挂载，保留现状：$(findmnt -no SOURCE,OPTIONS "$mnt")"

    # 已挂载但选项与声明不一致时提示（例如手工挂过、少了 nodatacow）
    IFS=, read -r -a declared <<<"$opts"
    for opt in "${declared[@]}"; do
      case ",$(findmnt -no OPTIONS "$mnt")," in
        *",$opt,"*) ;;
        *) echo "    警告：当前挂载缺少 $opt，需要时 umount $mnt 后重跑本脚本" ;;
      esac
    done
  else
    if [ -n "$(find "$mnt" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
      echo "    注意：$mnt 下有 @root 里的旧数据，挂载后会被遮住"
    fi
    run mount -o "$opts,subvol=$name" "$DEV" "$mnt"
    # docker data-root 保持 0710 root:root（dockerd 不会修正已存在的目录权限）
    if [ "$name" = docker ]; then run chmod 0710 "$mnt"; fi
    printf '    挂载: %s\n' "$(findmnt -no SOURCE,TARGET,FSTYPE,OPTIONS "$mnt" 2>/dev/null || echo '未挂载')"
  fi

  if mountpoint -q "$mnt"; then
    prop="$(btrfs property get "$mnt" compression 2>/dev/null || true)"
    printf '    compression property: %s\n' "${prop:-(查不到，需要 root；以 mount 选项为准)}"
  fi
done

echo ">>> 压缩实测（8MiB 全零文件；磁盘占用远小于 8M 即说明被压缩了）"
for entry in "${SUBVOLS[@]}"; do
  name="${entry%%:*}"
  rest="${entry#*:}"
  mnt="${rest%%:*}"
  selected "$name" || continue
  if [ "$DRY_RUN" = 1 ] || ! mountpoint -q "$mnt"; then
    echo "    $mnt: 跳过（dry-run 或未挂载）"
    continue
  fi
  tmp="$mnt/.subvol-compression-test"
  dd if=/dev/zero of="$tmp" bs=1M count=8 status=none
  printf '    %s: apparent %s / 已用 %s\n' "$mnt" \
    "$(du -h --apparent-size "$tmp" | cut -f1)" \
    "$(du -h "$tmp" | cut -f1)"
  rm -f "$tmp"
done

cat <<'EOF'

挂载已经在跑，但还要让声明生效（写进 fstab / 生成 mount unit）:
    just switch        # 等价于 nixos-rebuild switch --sudo --flake .#$(hostname)
EOF
