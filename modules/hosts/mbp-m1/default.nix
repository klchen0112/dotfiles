let
  machine = "mbp-m1";
in
{
  inputs,
  den,
  ...
}:
{
  #  sshKey = [    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"];
  den.hosts.aarch64-darwin.${machine} = {
    # roles = [
    #  "emacs-twist"
    #   #"zen"
    #   #"inputmethod"
    #   "ghostty"
    #   #"python"
    # ];
    roles = [
      #"stylix-home"
      #"emacs-twist"
      "ghostty"
      "kitty"
      "vscode"
      "nix"
      "inputmethod"
      "zen"
      "paneru"
      "zsh"
    ];
    users = {
      klchen = {
        roles = [
          #"stylix-home"
          #"emacs-twist"
          "ghostty"
          "kitty"
          "vscode"
          "nix"
          "inputmethod"
          "zen"
          "paneru"
          "zsh"
        ];
        # roles = [
        #
        #   #
        #   #
        #   "ghostty"
        #   #"python"
        #   #"aria2"
        #   #"kitty"
        #   #"syncthing"
        #   #"vscode"
        # ];

      };
    };
  };

  den.aspects.${machine} = {
    includes = with den.aspects; [
      homebrew
      stylix
      nix
      nixpkgs
    ];
    darwin =
      { pkgs, lib, ... }:
      {
        system.primaryUser = "klchen";
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
        ids.gids.nixbld = 30000;
      };
  };
}
