{
  pkgs,
  username,
  inputs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      home = {
        username = "${username}";
        homeDirectory = "/Users/${username}";
        stateVersion = "23.05";
      };
      imports = [
        inputs.nix-doom-emacs.hmModule

        ../../browser
        ../../downloader
        # ../../editors/codeblocks
        ../../editors/jetbrains
        ../../editors/emacs
        # ../../editors/vim
        # ../../editors/nvim
        ../../editors/vscode
        ../../graphics
        ../../keyboard
        ../../lang/cpp
        ../../lang/go
        ../../lang/json
        ../../lang/julia
        ../../lang/lua
        ../../lang/latex
        ../../lang/markdown
        ../../lang/nix
        ../../lang/nodejs
        ../../lang/python
        ../../lang/rust
        ../../media
        ../../shells
        ../../socialMedia
        ../../terminal
        # ../../vpn
      ];
    };
  };
}
