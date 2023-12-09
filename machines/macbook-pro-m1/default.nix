{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}: {

  imports = [
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs/darwin.nix
    ../../modules/system/darwin.nix
    ../../modules/desktop/yabai
    ../../modules/homebrew
    ../../modules/editors/darwin.nix
    ../../modules/downloader/module.nix
    ../../modules/downloader/darwin.nix
  ];

  users.users.${username} = {
    # macOS user
    home = "/Users/${username}";
    name = "${username}";
    shell = pkgs.fish; # Default shell
  };


  programs.fish.enable = true;

  environment = {
    shells = with pkgs; [ fish bash ]; # Default shell
    # variables = {
    #   # System variables
    #   EDITOR = "nvim";
    #   VISUAL = "nvim";
    # };
    systemPackages = with pkgs; [
      cachix
      # sketchybar
      # fontconfig
      gnugrep # replacee macos's grep
      gnutar # replacee macos's tar
      p7zip
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  services.activate-system.enable = true;


}

