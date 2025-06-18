{
  pkgs,
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
      };
      folders = {
        "rime-sync" = {
          path = "~/Library/Mobile Documents/iCloud~dev~fuxiao~app~hamsterapp/Documents/sync";
          devices = [
            "redmi-12t-pro"
            "tower"
          ];
        };
      };

    };
    tray = {
      enable = pkgs.stdenv.isLinux;
    };
  };

}
