{
  den.aspects.csharp.csharp =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ dotnet-runtime_8 ];
    };
}
