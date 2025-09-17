{
  flake.modules.homeManager.syncthing =
    {
      pkgs,
      config,
      ...
    }:
    {
      services.syncthing = {
        enable = true;
        settings = {
          devices = {
            redmi-12t-pro = {
              id = "RUZJDNU-KNB25U6-PPN5ZKI-LEOEKSW-MMNFVJO-W5PVV4M-WEJ4A7T-VTFWFAG";
            };
            tower = {
              id = "TOKPTBS-3B4SFW7-VRQODVL-Z3HX4IP-IZQ7Q5P-HM3NGY2-EOQJNGD-3Q5P7QC";
            };
            mbp-m1 = {
              id = "GXCTWCA-SM4LB6T-54QM33T-KZIJP36-PUMGKOV-PXRTEQS-C5WFI3D-S5EU5QY";
            };
            a99r50 = {
               id = "5W52MX5-JIZFA55-AP74KQ2-7QAI5OF-DZKSJ5M-KPBAHVD-ZVB67M5-WFYVAQC";
            };
          };
          folders = {
            "rime-sync" = {
              id = "w4pgi-mnhem";
              path =
                if pkgs.stdenv.isDarwin then
                  "~/Library/Mobile Documents/iCloud~dev~fuxiao~app~hamsterapp/Documents/sync"
                else
                  "${config.home.homeDirectory}/.local/share/rime-sync";
              devices = [
                "redmi-12t-pro"
                "tower"
                "mbp-m1"
              ];
            };
          };

        };
        tray = {
          enable = pkgs.stdenv.isLinux;
        };
      };
    };
}
