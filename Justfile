
# nix

up:
	git pull
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

i12r70:
	sudo nixos-rebuild switch --flake .#i12r70

a3400g:
	sudo nixos-rebuild switch --flake .#3400g

sanjiao:
	sudo nixos-rebuild switch --flake .#sanjiao

woniu:
	sudo nixos-rebuild switch --flake .#woniu

# macbook

mbp-m1:
	sudo darwin-rebuild switch --flake .#mbp-m1

mbp-dxm:
	sudo darwin-rebuild switch --flake .#mbp-dxm
# Emacs
emacs-test:
	rm -rf "$HOME/.config/doom"
	rsync -avz --copy-links --chmod=Du+rwx,Dgo+rx,Fu+rw,Fgo+r modules/editors/emacs/doom/ "$HOME/.config/doom"

emacs-clean:
	rm -rf "${HOME}/.config/doom"
