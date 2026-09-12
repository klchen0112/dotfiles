{
  den.aspects.bash.homeManager =
    {
      pkgs,
      ...
    }:
    {
      programs.bash = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
      };
      home.packages = with pkgs; [
        bash-language-server
        shellcheck
        shfmt
      ];
    };
}
