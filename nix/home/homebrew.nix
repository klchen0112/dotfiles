{ pkgs, lib, inputs, system, ... }:

{
  #
  homebrew =
    {

      enable = true;
      onActivation = {
        upgrade = true;
        cleanup = "uninstall";
      };
      masApps = {
        wechat = 836500024;
        qq = 451108668;
        dingtalk = 1435447041;
        tencent-meeting = 1484048379;
        emby = 992180193;
        "microsoft-word" = 462054704;
        "microsoft-powerpoint" = 462062816;
        "microsoft-excel" = 462058435;
        onedrive = 823766827;
        "goodnotes-5" = 1444383602;
      };
      taps = [
        "homebrew/cask"
        "homebrew/cask-fonts"
        "homebrew/core"
        "homebrew/services"
      ];
      brews = [
        # "lua"
        # "luarocks"
        "mas"
        "pngpaste" # for emacs download clipboard
      ];
      casks = [
        "adrive"
        "font-sf-pro"
        "snipaste"
        "anki"
        "google-chrome"
        "steam"
        "appcleaner"
        "hammerspoon"
        "sublime-text"
        "authy"
        "hiddenbar"
        "telegram"
        "baidunetdisk"
        "iterm2"
        "balenaetcher"
        "keyboardcleantool"
        "todesk"
        "calibre"
        "marginnote"
        "vial"
        "dash"
        "nutstore"
        "visual-studio-code"
        "omnidisksweeper"
        "vlc"
        "discord"
        "plex"
        "plexamp"
        "font-sf-arabic"
        "xnviewmp"
        "font-sf-compact"
        "raycast"
        "zerotier-one"
        "font-sf-mono"
        "sioyek"
        "zotero"
      ];

    };

}
