# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

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
switch:
    nixos-rebuild switch --sudo --flake .#"$(shell hostname)"

[group('dev')]
disko-install arg1:
    sudo nix  --experimental-features "nix-command flakes"  run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '.#init' --disk main {{ arg1 }}

[group('dev')]
gen:
    nixos-generate-config --root /tmp/config --no-filesystems
    cp /tmp/config/etc/nixos/hardware-configuration.nix ./configurations/nixos/init/

write:
    nix run .#write-flake
