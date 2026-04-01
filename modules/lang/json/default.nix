{
  den.aspects.json.json =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jq
      ];
    };
}
