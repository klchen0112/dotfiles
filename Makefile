# nix

up:
	nix flake update


darwin:
	darwin-rebuild switch --flake .#macbook-pro-m1


fmt:
	nix fmt
