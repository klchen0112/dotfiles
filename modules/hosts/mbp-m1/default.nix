{ inputs,config, ... }:
{
  flake.modules.darwin.mbp-m1 = {
    imports = with inputs.self.modules.darwin; [
      klchen
      # homebrew
    ];
     home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
      # git
     ];
    system.primaryUser = "klchen";
    ids.gids.nixbld = 30000;
  };
}
