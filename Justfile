
# nix

up:
	nix flake update

check:
	nix flake check

fmt:
	nix fmt

gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

gitgc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now
  
# i12500

i12500:
	sudo nixos-rebuild switch --flake .#i12500

klcheni12500:
	home-manager switch --flake .#klchen@i12500

# macbook

darwin:
	darwin-rebuild switch --flake .#macbook-pro-m1

# Emacs
emacs-test:
	rm -rf "$HOME/.config/doom"
	rsync -avz --copy-links --chmod=Du+rwx,Dgo+rx,Fu+rw,Fgo+r modules/editors/emacs/doom/ "$HOME/.config/doom"

emacs-clean:
	rm -rf "${HOME}/.config/doom"
