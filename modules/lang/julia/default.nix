{
  flake.modules.homeManager.julia =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        julia
      ];
    };
}
