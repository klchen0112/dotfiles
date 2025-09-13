let
  fonts_settings =
    {
      pkgs,
      ...
    }:
    {
      fonts.packages =
        with pkgs;
        [
          # icon fonts
          material-design-icons
          font-awesome

          # mono fonts for coding
          iosevka
          nerd-fonts."m+"

          # Serif fonts
          ibm-plex

          # emoji
          twemoji-color-font
          noto-fonts-emoji # 彩色的表情符号字体

          # symbol font
          # symbola

          # chinese font
          lxgw-wenkai

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
          noto-fonts-extra # 提供额外的字重和宽度变种

          local.TsangerJinKai03
          local.Jigmo
          nerd-fonts.symbols-only
          nerd-fonts.hack
        ]
        ++ (lib.optionals pkgs.stdenv.isDarwin [

          local.sf-mono-liga
          local.SF-Pro
          local.sf-symbols

        ]);
    };
in
{
  flake.modules.nixos.font = fonts_settings;

  flake.modules.darwin.font = fonts_settings;

}
