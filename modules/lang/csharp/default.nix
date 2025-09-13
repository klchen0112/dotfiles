{
  flake.modules.homeManager.csharp =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ dotnet-runtime_8 ];
    };
}
