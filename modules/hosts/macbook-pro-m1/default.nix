{pkgs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.chenkailong = {
      pkgs,
      user,
      ...
    }: {
      home = {
        username = "chenkailong";
        homeDirectory = "/Users/chenkailong";
        stateVersion = "22.11";
        # shell = pkgs.fish;
      };
      imports = [
        #  ../../browser
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
        ../../terminal
        # ../../vpn
      ];
    };
  };
}
