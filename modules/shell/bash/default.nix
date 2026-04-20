{
  den.aspects.bash.hmLinux =
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
