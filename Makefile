# nix

up:
	nix flake update

check:
	nix flake check

fmt:
	nix fmt

# i12500

i12500:
	sudo nixos-rebuild switch --flake ~/myOpenSource/dotfiles#i12500

klcheni12500:
	home-manager switch --flake ~/myOpenSource/dotfiles#klchen@i12500

# macbook

darwin:
	darwin-rebuild switch --flake .#macbook-pro-m1
