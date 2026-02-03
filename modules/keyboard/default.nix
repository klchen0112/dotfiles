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
  flake.modules.nixos.keyboard =
    { pkgs, ... }:
    {
      hardware.keyboard.qmk.enable = true;
      environment.systemPackages = with pkgs; [
        qmk
        vial
        vial
      ];
      services.udev = {
        enable = true;
        packages = with pkgs; [
          qmk
          qmk-udev-rules # the only relevant
          qmk_hid
          via
          vial
        ]; # packages

      }; # udev

    };
}
