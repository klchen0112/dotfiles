{ pkgs, inputs, system, ... }:
{
  # Key packages required on nixos and macos
  home.packages = with pkgs; [
    # Unixy tools
    gnumake
    ripgrep
    htop
    inputs.comma.packages.${system}.default
  ];

  programs = {
    exa.enable = true;
    bat.enable = true;

    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
