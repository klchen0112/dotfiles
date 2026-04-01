{
  den.aspects.starship.homeManager = {
    stylix.targets.starship.enable = true;
    programs.starship = {
      enable = true;
      enableInteractive = true;
      enableTransience = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

  };
}
