#
# ../../browser
#
{ pkgs, ... }: {
  programs.google-chrome = {
    enable =
      if pkgs.stdenv.isLinux
      then true
      else false;
    package = pkgs.google-chrome;
  };
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;
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
