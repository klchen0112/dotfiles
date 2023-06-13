{
  pkgs,
  username,
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
        ../../lang/json
        ../../lang/julia
        ../../lang/lua
        ../../lang/latex
        ../../lang/markdown
        ../../lang/nix
        ../../lang/nodejs
        ../../lang/python
        ../../lang/rust
        ../../reader
        ../../shells/git
        ../../shells/fish
        # ../../shells/zsh
        ../../shells/shell
        ../../socialMedia
        ../../terminal
        # ../../vpn
      ];
    };
  };
}
