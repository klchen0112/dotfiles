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
            vivoY300T = {
              id = "7Y6E2VH-HF7IDIW-KO6PBAK-GPZP7CV-2XNJSKS-WLWF4WH-YNQAS74-IW5YXAJ";
            };
          };
        };
        tray = {
          enable = pkgs.stdenv.isLinux;
        };
      };
    };
}
