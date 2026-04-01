let
  machine = "mbp-m1";
in
{
  inputs,
  config,
  lib,
  ...
}:
{
  #  sshKey = [    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"];
  den.hosts.aarch64-darwin.${machine} = {
    klchen = { };
  };

  den.aspects.${machine} =
    { den, ... }:
    {
      imports = with den.aspects; [
        homebrew
        stylix
      ];
      darwin =
        { pkgs, ... }:
        {
          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";

          #        home-manager.users.klchen.imports = with config.den.aspects.homeManager; [
          #          zsh
          #          # hammerspoon
          #          paneru
          #          homebrew
          #          ghostty
          #          aria2
          #          vscode
          #          inputmethod
          #          zen
          #          syncthing
          #          emacs-twist
          #          keyboard
          #          darwin
          #          # access-tokens
          #          # aerospace
          #          # aero-sketchybar
          #          latex
          #        ];
          ids.gids.nixbld = 30000;
        };
    };
}
