{ pkgs, lib, inputs, system, ... }:

{
  #
  homebrew =
    {

      enable = true;
      taps = [
        "homebrew/autoupdate"
        "homebrew/cask"
        "homebrew/cask-fonts"
        "homebrew/core"
        "homebrew/services"
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
        "tencent-meeting"
        "balenaetcher"
        "keyboardcleantool"
        "todesk"
        "calibre"
        "marginnote"
        "vial"
        "dash"
        "nutstore"
        "visual-studio-code"
        "dingtalk"
        "omnidisksweeper"
        "vlc"
        "discord"
        "plexamp"
        "wechat"
        "miniconda"
        "font-sf-arabic"
        "qq"
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
