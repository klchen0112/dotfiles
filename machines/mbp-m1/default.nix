{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  isWork ? true,
  ...
}: {
  imports = [
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs/darwin.nix
    ../../modules/system/darwin.nix
    ../../modules/desktop/yabai
    ../../modules/homebrew
    ../../modules/downloader/darwin.nix
    ../../modules/secrets
  ];

  users.users.${username} = {
    # macOS user
    home = "/Users/${username}";
    name = "${username}";
    shell = pkgs.fish; # Default shell
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment = {
    shells = with pkgs; [fish bash]; # Default shell
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
