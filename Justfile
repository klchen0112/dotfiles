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
init-disk:
  sudo nix  --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destory,format,mount ./configurations/nixos/a99r50/disko.nix

[group('dev')]
gen:
  sudo nixos-generate-config --no-filesystems --root /mnt

[group('dev')]
install:
  sudo nixos-install --root /mnt --flake '.#a99r50'
