{
  flake.modules.homeManager.json =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jq
      ];
    };
}
