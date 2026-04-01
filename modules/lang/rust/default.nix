{
  den.aspects.rust.rust =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rust-analyzer
        cargo # rust package manager
        rustfmt
      ];
    };
}
