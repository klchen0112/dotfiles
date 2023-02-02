{ pkgs, inputs, system, ... }:
{
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      mononoki
      symbola
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # noto-fonts-lgc-plus
      lxgw-wenkai
      liberation_ttf
      overpass
      freefont_ttf
      source-code-pro
      source-sans-pro
      source-serif-pro
      sarasa-gothic
      iosevka
      cm_unicode
      hanazono
      lmodern
      # lmmath
      # nerdfonts
      material-design-icons
      weather-icons
      emacs-all-the-icons-fonts
    ];
  };
}
