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
      ../../modules/account/home.nix
      ../../modules/editors/emacs/home.nix
      ../../modules/lang/home.nix
      ../../modules/network/home.nix
      ../../modules/sync/home.nix
      ../../modules/shells/home.nix
      ../../modules/terminal/home.nix
      ../../modules/visualisation/home.nix
      ../../modules/nixpkgs/home.nix
      ../../modules/stylix/home.nix
      ../../modules/secrets/home.nix
    ]
    ++ lib.optionals isWork [
      ../../modules/lang/tools/home.nix
    ];

  programs.home-manager.enable = true;
  backupFileExtension = "backup";
}
