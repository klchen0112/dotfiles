{
  den.aspects.docker =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ dockfmt ];
    };
}
