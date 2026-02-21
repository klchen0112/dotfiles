{ inputs, ... }:
let
  fonts_settings =
    {
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        inputs.chinese-fonts-overlay.overlays.default
      ];
      fonts.packages = with pkgs; [
        # icon fonts
        material-design-icons
        font-awesome

        # mono fonts for coding
        nerd-fonts."m+"

        # Serif fonts
        ibm-plex

        # emoji
        twemoji-color-font
        noto-fonts-color-emoji # 彩色的表情符号字体
        # symbol font
        symbola

        # chinese font

        liberation_ttf
        overpass
        freefont_ttf

        cm_unicode
        hanazono
        lmodern
        lmmath

        # Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作 tofu
        # Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。
        # 其中汉字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最后一个词是地区变种。
        noto-fonts # 大部分文字的常见样式，不包含汉字
        noto-fonts-cjk-sans # 汉字部分

        nerd-fonts.symbols-only
        nerd-fonts.hack

        tsangertypeFonts.jinkai-05-w03
      ];
    };
in
{
  flake-file.inputs = {
    chinese-fonts-overlay.url = "github:brsvh/chinese-fonts-overlay";
  };

  flake.modules.nixos.font = fonts_settings;

  flake.modules.darwin.font = fonts_settings;

  flake.modules.homeManager.font = {
    fonts.fontconfig.defaultFonts = {
      serif = [
        "CMU Typewriter Text"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "TsangerJinKai05"
        "Noto Sans CJK SC"
        "IBM Plex Serif"
      ];
      monospace = [
        "M+CodeLat50 Nerd Font Propo"
        "Noto Sans Mono CJK SC"
        "Sarasa Mono SC"
        "DejaVu Sans Mono"
      ];
      emoji = [
        "Noto Color Emoji"
        "Seagoe UI Emoji"
        "Twitter Color Emoji"
      ];
    };
  };
}
