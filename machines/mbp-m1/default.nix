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
  imports = [
    ../../modules/account/darwin.nix
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs/darwin.nix
    ../../modules/system/darwin.nix
    # ../../modules/desktop/skhd
    # ../../modules/desktop/yabai
    ../../modules/desktop/areospace
    ../../modules/homebrew
    ../../modules/downloader/darwin.nix
    ../../modules/secrets/darwin.nix
    ../../modules/stylix/darwin.nix
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment = {
    shells = with pkgs; [
      fish
      bash
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
  services.openssh.enable = true;

}
