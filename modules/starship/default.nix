{
  stylix.targets.starship.enable = true;
  programs.starship = {
    enable = true;
    enableInteractive = true;
    enableFishIntegration = false;
    enableZshIntegration = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

}
