{
  flake.modules.homeManager.markdown =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        python312Packages.grip
      ];
    };
}
