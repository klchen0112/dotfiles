# nix

i12500:
	sudo nixos-rebuild switch --flake ~/myOpenSource/dotfiles#i12500

klcheni12500:
	home-manager switch --flake ~/myOpenSource/dotfiles#klchen@i12500

darwin:
	darwin-rebuild switch --flake .#macbook-pro-m1


up:
	nix flake update

fmt:
	nix fmt
