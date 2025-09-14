{ inputs, config, ... }:
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

    ];
    home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
      # git
      hammerspoon
      homebrew
      ghostty
      aria2
      vscode
      inputmethod
    ];
    home-manager.backupFileExtension = "hmbp";
    system.primaryUser = "klchen";
    ids.gids.nixbld = 30000;
  };
}
