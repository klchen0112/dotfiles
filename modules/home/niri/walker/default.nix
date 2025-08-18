{ pkgs, flake, ... }:
{
  imports = [ flake.inputs.walker.homeManagerModules.default ];
  services.walker = {
    enable = true;
    runAsService = true;
  };
  nix.settings = {
    # add binary caches
    trusted-public-keys = [
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
    substituters = [
      "https://walker-git.cachix.org"
    ];
  };
}
