{ inputs, ... }:
{
  flake-file.inputs = {
    zen-browser = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      url = "github:0xc000022070/zen-browser-flake";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };
  flake.modules.homeManager.zen =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
        # inputs.nix-darwin-browsers.overlays
      ];
      programs.zen-browser = {
        enable = true;
        enableGnomeExtensions = false;
        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };
        profiles = {
          "${config.home.username}" = {
            id = 0;
            isDefault = true;
            name = "${config.home.username}";
            search = {
              force = true;
              default = "ddg";
              order = [
                "bing"
                "Baidu"
                "ddg"
                "google"
              ];
            };
            containersForce = true;
            containers = {
              Personal = {
                color = "purple";
                icon = "fingerprint";
                id = 1;
              };
              Work = {
                color = "blue";
                icon = "briefcase";
                id = 2;
              };
              Shopping = {
                color = "yellow";
                icon = "dollar";
                id = 3;
              };
            };
            spacesForce = true;
            spaces =
              let
                containers = config.programs.zen-browser.profiles."${config.home.username}".containers;
              in
              {
                "Space" = {
                  id = "c6de089c-410d-4206-961d-ab11f988d40a";
                  position = 1000;
                };
                "Work" = {
                  id = "cdd10fab-4fc5-494b-9041-325e5759195b";
                  icon = "chrome://browser/skin/zen-icons/selectable/star-2.svg";
                  container = containers."Work".id;
                  position = 2000;
                };
                "Shopping" = {
                  id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
                  icon = "💸";
                  container = containers."Shopping".id;
                  position = 3000;
                };
              };
            settings = {
              "browser.tabs.loadInBackground" = true;
              #   "widget.gtk.rounded-bottom-corners.enabled" = true;
              #   "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "svg.context-properties.content.enabled" = true;
              bookmarks = [
                {
                  name = "wikipedia";
                  tags = [ "wiki" ];
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
                      tags = [
                        "wiki"
                        "nix"
                      ];
                      url = "https://nixos.wiki/";
                    }
                    {
                      name = "mynixios";
                      tags = [
                        "wiki"
                        "nix"
                      ];
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
                      tags = [ "anime" ];
                      url = "https://www.bilibili.com/";
                    }
                    {
                      name = "BGM";
                      tags = [ "anime" ];
                      url = "https://bgm.tv/";
                    }
                  ];
                }
              ];
            };
            extensions.packages = with inputs.nur.legacyPackages."${pkgs.system}".repos.rycee.firefox-addons; [
              # see: https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
              augmented-steam
              # auto-sort-bookmarks
              # auto-tab-discard
              # automatic-dark
              # gopass-bridge
              # https-everywhere
              # link-cleaner
              privacy-badger
              # tree-style-tab
              # multi-account-containers
              # firefox-translations # translation
              # immersive-translate
              tridactyl # vimum
              bitwarden
              blocktube
              rsshub-radar
              # brotab
              # onetab
              ublock-origin
              zotero-connector
              copy-as-org-mode
              violentmonkey
              tab-session-manager
              auto-tab-discard
            ]
            # ++ (with pkgs.firefox-addons; [
            #   online-dictionary-helper
            # ])
            ;
          };
        };
      };
    };
}
