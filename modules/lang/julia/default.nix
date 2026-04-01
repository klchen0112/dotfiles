{
  den.aspects.julia.julia =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        julia
      ];
    };
}
