#
# OpenVPN
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     cursor = {
  #       style = "Block";
  #     };

  #     window = {
  #       opacity = 1.0;
  #       padding = {
  #         x = 24;
  #         y = 24;
  #       };
  #     };

  #     font = {
  #       normal = {
  #         family = "Jetbrains Mono";
  #         style = "Regular";
  #       };
  #       size = lib.mkMerge [
  #         (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
  #         (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
  #       ];
  #     };

  #     dynamic_padding = true;
  #     decorations = "full";
  #     title = "Terminal";
  #     class = {
  #       instance = "Alacritty";
  #       general = "Alacritty";
  #     };

  #     colors = {
  #       primary = {
  #         background = "0x1f2528";
  #         foreground = "0xc0c5ce";
  #       };

  #       normal = {
  #         black = "0x1f2528";
  #         red = "0xec5f67";
  #         green = "0x99c794";
  #         yellow = "0xfac863";
  #         blue = "0x6699cc";
  #         magenta = "0xc594c5";
  #         cyan = "0x5fb3b3";
  #         white = "0xc0c5ce";
  #       };

  #       bright = {
  #         black = "0x65737e";
  #         red = "0xec5f67";
  #         green = "0x99c794";
  #         yellow = "0xfac863";
  #         blue = "0x6699cc";
  #         magenta = "0xc594c5";
  #         cyan = "0x5fb3b3";
  #         white = "0xd8dee9";
  #       };
  #     };
  #   };
  # };
  programs.kitty = {
    enable = true;
    theme = "Doom One Light";
    # font = pkgs.jetbrains-mono;
    settings = {
      font_family = "JetBrains Mono Medium";
      bold_font = "JetBrains Mono Bold";
      italic_font = "JetBrains Mono Italic";
      bold_italic_font = "JetBrains Mono Bold Italic";
      font_size = 16;
      remeber_window_size = true;
      initial_window_width = 640;
      initial_window_height = 400;
    };
  };
}
