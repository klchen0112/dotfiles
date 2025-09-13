{
  flake.modules.homeManager.lua =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lua5_4_compat
        lua-language-server
      ];
    };
}
