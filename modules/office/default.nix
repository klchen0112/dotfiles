{
  den.aspects.office =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wpsoffice
      ];
    };
}
