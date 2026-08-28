#!/usr/bin/env bash
set -euo pipefail

device=${1:-}
if [[ -z "$device" ]]; then
  echo "usage: iso-burn DEVICE" >&2
  exit 1
fi

shopt -s nullglob
isos=( result/iso/*.iso )
if (( ${#isos[@]} == 0 )); then
  echo "No ISO found in result/iso/. Build one first: just iso" >&2
  exit 1
fi

if (( ${#isos[@]} == 1 )); then
  iso=${isos[0]}
  echo "Using ISO: $iso"
else
  echo "Available ISOs in result/iso/:"
  for i in "${!isos[@]}"; do
    printf '%2d) %s\n' "$((i + 1))" "${isos[$i]}"
  done
  read -r -p "Select ISO [1-${#isos[@]}]: " n
  if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > ${#isos[@]} )); then
    echo "Invalid selection" >&2
    exit 1
  fi
  iso=${isos[$((n - 1))]}
fi

if [[ ! -b "$device" ]]; then
  echo "error: $device is not a block device" >&2
  exit 1
fi

size=$(lsblk -dn -o SIZE "$device" 2>/dev/null || echo '?')
echo "ISO:  $iso"
echo "Disk: $device ($size)"
read -r -p "Type 'yes' to erase $device and write the ISO: " ans
if [[ "$ans" != "yes" ]]; then
  echo "aborted" >&2
  exit 1
fi

sudo umount "$device"?* 2>/dev/null || true
sudo dd if="$iso" of="$device" bs=4M status=progress conv=fsync
sync
echo "Done."
