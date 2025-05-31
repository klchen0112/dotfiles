#
# OpenVPN
#
{
  pkgs,
  lib,
  config,
  #
  ...
}:
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    environment = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      TERM = "xterm-256color";
    };
    shellIntegration = {
      enableFishIntegration = true;
    };

    settings = {
      #-------------------------------------------- Font --------------------------------------------
      font_family = if pkgs.stdenv.isLinux then "Iosevka Nerd Font" else "SF Mono";
      font_size = 14;

      #-------------------------------------------- Window --------------------------------------------
      hide_window_decorations = if pkgs.stdenv.isDarwin then "titlebar-only " else true;
      # Animation
      cursor_trail = 3;
      #-------------------------------------------- Mouse --------------------------------------------
      url_prefixes = "http https file ftp";
      copy_on_select = true;

      detect_urls = true;

      #-------------------------------------------- Shell --------------------------------------------
      shell =
        if pkgs.stdenv.isDarwin then
          "/etc/profiles/per-user/${config.me.username}/bin/fish --login --interactive"
        else
          "/etc/profiles/per-user/${config.me.username}/bin/fish";
      #-------------------------------------------- Theme --------------------------------------------
      background_opacity = lib.mkForce 0.8;
      #-------------------------------------------- Macos Settings --------------------------------------------

      macos_titlebar_color = "system";
      macos_option_as_alt = true;
      macos_hide_from_tasks = false;
      macos_quit_when_last_window_closed = false;
      macos_window_resizable = true;
      macos_thicken_font = 0.75;
      macos_traditional_fullscreen = false;
      macos_show_window_title_in = "all";
      macos_colorspace = "displayp3";
    };
  };


}
