host := `hostname`

# Default command when 'just' is run without arguments
default:
    @just --list

# Update nix flake
[group('Main')]
update:
    nix flake update

# Lint nix files
[group('dev')]
lint:
    nix fmt

# Check nix flake
[group('dev')]
check:
    nix flake check

# Manually enter dev shell
[group('dev')]
dev:
    nix develop

# Activate the configuration
[group('Main')]
run:
    nix run

[group('dev')]
switch HOST=`hostname`:
    just switch-{{ os() }} "{{ HOST }}"

# macOS 构建命令
switch-macos HOST=`hostname`:
    sudo darwin-rebuild switch --flake .#"{{ HOST }}"

# NixOS 构建命令
switch-linux HOST=`hostname`:
    nixos-rebuild switch --sudo --flake .#"{{ HOST }}"

[group('dev')]
disko-install arg1:
    sudo nix  --experimental-features "nix-command flakes" --accept-flake-config run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '.#init' --disk main {{ arg1 }} 

# Build init live ISO image (output: result/iso/*.iso)
[group('dev')]
iso:
    nix build --accept-flake-config .#nixosConfigurations.init.config.system.build.isoImage

# Burn the built ISO to a USB device (e.g. /dev/sdb, rebuilds first)
[group('dev')]
iso-burn DEVICE:
    sudo dd if=result/iso/*.iso of={{ DEVICE }} bs=4M status=progress conv=fsync

[group('dev')]
gen:
    nixos-generate-config --root /tmp/config --no-filesystems
    cp /tmp/config/etc/nixos/hardware-configuration.nix ./configurations/nixos/init/

write:
    nix run .#write-flake

deploy:
    deploy --skip-checks --interactive-sudo true
