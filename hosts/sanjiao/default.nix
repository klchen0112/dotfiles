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
      ../../modules/editors/emacs/home.nix
      # ../../modules/lang/home.nix
      ../../modules/network/home.nix
      ../../modules/sync/home.nix
      ../../modules/shells/home.nix
      ../../modules/terminal/home.nix
      # ../../modules/visualisation/home.nix
      ../../modules/nixpkgs/home.nix
      ../../modules/account/home.nix
      ../../modules/stylix/home.nix
      ../../modules/secrets/home.nix
    ]
    ++ lib.optionals isWork [
      ../../modules/lang/tools/home.nix
    ];
  programs.home-manager.enable = true;
  home-manager.backupFileExtension = "backup";
}
