{
  den.aspects.bash.homeManager =
    {
      pkgs,
      ...
    }:
    {
      programs.bash = {
        enable = pkgs.stdenv.isLinux;
      };
      home.packages = with pkgs; [
        bash-language-server
        shellcheck
        shfmt
      ];
    };
}
