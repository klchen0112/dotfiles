#
# ../../browser
#
{
  pkgs,
  lib,
  isWork,
  ...
}: {
  programs.google-chrome = {
    enable = pkgs.stdenv.isLinux;
    package = pkgs.google-chrome;
  };
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;
    enableGnomeExtensions = false;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.firefox-bin
      else pkgs.firefox-wayland; # firefox with wayland support
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "klchen";
      search = {
        force = true;
        default = "DuckDuckGo";
        order = ["Bing" "Baidu" "DuckDuckGo" "Google"];
      };
      settings = {
        "browser.tabs.loadInBackground" = true;
        #   "widget.gtk.rounded-bottom-corners.enabled" = true;
        #   "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        bookmarks = [
          {
            name = "wikipedia";
            tags = ["wiki"];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
          {
            name = "kernel.org";
            url = "https://www.kernel.org";
          }
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "Home Manager";
                url = "https://nixos.wiki/wiki/Home_Manager";
              }
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                name = "wiki";
                tags = ["wiki" "nix"];
                url = "https://nixos.wiki/";
              }
              {
                name = "mynixios";
                tags = ["wiki" "nix"];
                url = "https://mynixos.com/";
              }
            ];
          }
          {
            name = "动画";
            toolbar = true;
            bookmarks = [
              {
                name = "bilibili";
                tags = ["anime"];
                url = "https://www.bilibili.com/";
              }
              {
                name = "BGM";
                tags = ["anime"];
                url = "https://bgm.tv/";
              }
            ];
          }
        ];
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # see: https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
        augmented-steam
        # auto-sort-bookmarks
        # auto-tab-discard
        # automatic-dark
        # gopass-bridge
        # https-everywhere
        # link-cleaner
        # privacy-badger
        # tree-style-tab
        # multi-account-containers
        # firefox-translations # translation
        immersive-translate
        tridactyl # vimum
        sidebery
        bitwarden
        omnivore
        blocktube
        rsshub-radar
        # brotab
        onetab
        ublock-origin
        zotero-connector
        copy-as-org-mode
        # online-dictionary-helper
      ];
    };

    # home.packages = with pkgs; [tor];
  };
}
