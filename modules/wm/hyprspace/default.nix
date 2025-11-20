{
  flake.modules.homeManager.hyprspace =
    { pkgs, config ,... }:
    {
      # programs.aerospace = {
      #   enable = true;
      #   package = null;
      #   userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      # };
      home.file.".hyprspace.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my/dotfiles/modules/wm/hyprspace/aerospace.toml";
    };
}
