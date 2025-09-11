{
  flake.modules.homeManager.yaml =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yaml-language-server
      ];
    };
}
