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

# 或者使用条件判断：
[group('dev')]
switch:
    just switch-{{os()}}


# macOS 构建命令
switch-macos:
	sudo darwin-rebuild switch --flake .#{{ host }}

# NixOS 构建命令  
switch-nixos:
	sudo nixos-rebuild switch --flake .#{{ host }}

[group('dev')]
disko-install arg1:
    sudo nix  --experimental-features "nix-command flakes"  run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '.#init' --disk main {{ arg1 }}

[group('dev')]
gen:
    nixos-generate-config --root /tmp/config --no-filesystems
    cp /tmp/config/etc/nixos/hardware-configuration.nix ./configurations/nixos/init/

write:
    nix run .#write-flake
