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
  flake.meta.machines.${machine} = {
    hostName = machine;
    platform = "aarch64-darwin";
    base16Scheme = "selenized-dark";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"
    ];
    users = [ "klchen" ];
    desktop = true;
  };
  flake.modules.darwin.${machine} = {
    nixpkgs.system = config.flake.meta.machines.${machine}.platform;
    imports =
      with inputs.self.modules.darwin;
      [
        homebrew
        access-tokens
        aerospace
      ]
      ++ (builtins.map (
        user: inputs.self.modules.darwin.${user}
      ) config.flake.meta.machines.${machine}.users);
    home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
      zsh
      hammerspoon
      homebrew
      ghostty
      aria2
      vscode
      inputmethod
      zen
      syncthing
      emacs-twist
      keyboard
      darwin
      access-tokens
      # aerospace
      # aero-sketchybar
      latex
    ];
    home-manager.backupFileExtension = "hmbp";
    system.primaryUser = lib.lists.head config.flake.meta.machines.${machine}.users;
    ids.gids.nixbld = 30000;
  };
}
