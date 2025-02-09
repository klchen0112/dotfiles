{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork,
  ...
}:
{
  imports =
    [
      # ../../modules/editors/emacs/home.nix
      ../../modules/lang/home.nix
      ../../modules/network/home.nix
      ../../modules/sync/home.nix
      ../../modules/shells/home.nix
      ../../modules/terminal/home.nix
      # ../../modules/visualisation/home.nix
      ../../modules/nixpkgs/home.nix
    ]
    ++ lib.optionals isWork [
      ../../modules/lang/tools/home.nix
    ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

}
