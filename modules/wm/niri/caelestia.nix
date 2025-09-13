{
  flake.modules.homeManager.niri-caelestia-shell =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.niri-caelestia-shell.homeManagerModules.default

      ];
      programs.caelestia = {
        enable = true;
        cli.enable = true;
      };
      programs.fuzzel = {
        enable = true;
      };

    };
}
