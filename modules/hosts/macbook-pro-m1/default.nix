{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.chenkailong = {
      pkgs,
      pkgs-unstable,
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
        ../../editors/emacs
        ../../editors/vim
        # ../../editors/nvim
        ../../editors/vscode
        ../../lang/cpp
        ../../lang/julia
        ../../lang/lua
        ../../lang/latex
        ../../lang/markdown
        ../../lang/nix
        ../../lang/nodejs
        ../../lang/python
        # ../../reader
        ../../shells/git
        ../../shells/fish
        ../../shells/zsh
        ../../shells/shell
        ../../terminal
        # ../../vpn
      ];
    };
  };
}
