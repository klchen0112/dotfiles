{
  flake.modules.homeManager.keyboard =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          qmk
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          vial
        ];
    };
}
