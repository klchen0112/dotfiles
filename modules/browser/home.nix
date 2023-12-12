#
# ../../browser
#
{ pkgs, ... }: {
  programs.google-chrome = {
    enable = pkgs.stdenv.isLinux;
    package = pkgs.google-chrome;
  };
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = false;
    package =
      if pkgs.stdenv.isDarwin then
        pkgs.nur.repos.toonn.apps.firefox
      else
        pkgs.firefox-wayland; # firefox with wayland support
    profiles = {
      "klchen" = {
        id = 0;
        settings = { };
        search = {
          force = true;
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" "Google" ];
        };
        # extensions = with
      };
    };
    # home.packages = with pkgs; [tor];
  };
}
