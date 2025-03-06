{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  isWork ? true,
  ...
}:
{
  ids.gids.nixbld = 350;
  imports = [
    ../../modules/account
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs/darwin.nix
    ../../modules/system/darwin.nix
    # ../../modules/desktop/skhd
    # ../../modules/desktop/yabai
    ../../modules/desktop/areospace
    ../../modules/homebrew
    ../../modules/downloader/darwin.nix
    ../../modules/secrets
    ../../modules/stylix/darwin.nix
    ../../modules/account
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment = {
    shells = with pkgs; [
      fish
      bash
      zsh
    ]; # Default shell
    # variables = {
    #   # System variables
    #   EDITOR = "nvim";
    #   VISUAL = "nvim";
    # };
    systemPackages = with pkgs; [
      coreutils # gnu ls
      cachix
      # sketchybar
      # fontconfig
      gnugrep # replacee macos's grep
      gnutar # replacee macos's tar
      p7zip
      coreutils
    ];
  };
}
