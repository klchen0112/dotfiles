{
  den.aspects.bash.hmLinux =
    {
      pkgs,
      ...
    }:
    {
      programs.bash = {
        enable = true;
      };
      home.packages = with pkgs; [
        nodePackages.bash-language-server
        shellcheck
        shfmt
      ];
    };
}
