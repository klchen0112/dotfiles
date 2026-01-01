{
  flake.modules.darwin.hyprspace = {
    homebrew = {
      taps = [
        "BarutSRB/tap"
      ];
      casks = [
        "hyprspace"
      ];
    };
  };
  flake.modules.homeManager.hyprspace =
    { pkgs, config, ... }:
    {
      # programs.aerospace = {
      #   enable = true;
      #   package = null;
      #   userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      # };
      home.file.".hyprspace.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my/dotfiles/modules/de/hyprspace/aerospace.toml";
    };
}
