{ inputs, config, lib,... }:
{
  flake.meta.machines.mbp-m1 = {
    hostName = "mbp-m1";
    platform = "aarch64-darwin";
    base16Scheme = "selenized-dark";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"
    ];
    users = [ "klchen" ];
    desktop = true;
  };
  flake.modules.darwin.mbp-m1 = {
    imports = with inputs.self.modules.darwin; [
      klchen
      homebrew
      access-tokens
    ];
    system.defaults.NSGlobalDomain._HIHideMenuBar = lib.mkForce false;
    home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
      zsh
      # hammerspoon
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
      hyprspace
      # aero-sketchybar
    ];
    home-manager.backupFileExtension = "hmbp";
    system.primaryUser = "klchen";
    ids.gids.nixbld = 30000;
  };
}
