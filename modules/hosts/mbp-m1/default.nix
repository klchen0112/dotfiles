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
  den.hosts.aarch64-darwin.${machine} =
    let
      common_roles = [
        "python"
        "emacs-twist"
        "zen"
        "inputmethod"
        "ghostty"
        "aria2"
        "kitty"
        "syncthing"
        "vscode"
        "im"
        "latex"
        "python"
        "paneru"
        "vscode"
        "stylix-home"
      ];
    in
    {

      roles = common_roles;
      users = {
        klchen.roles = common_roles;
      };
      klchen = { };
    };

  den.aspects.${machine} = {
    includes = with den.aspects; [
      homebrew
      stylix
      klchen
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
