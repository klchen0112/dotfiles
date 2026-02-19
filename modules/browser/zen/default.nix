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
    firefox-addons = {
      url = "github:osipog/nix-firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.homeManager.zen =
    {
      pkgs,
      config,
      ...
    }:
    {
      nixpkgs.overlays = [
        inputs.firefox-addons.overlays.default
      ];
      imports = [
        inputs.zen-browser.homeModules.beta
        # inputs.nix-darwin-browsers.overlays
      ];
      stylix.targets.zen-browser.profileNames = [ "${config.home.username}" ];
      xdg.mimeApps =
        let
          value =
            let
              zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform}.beta; # or twilight
            in
            zen-browser.meta.desktopFileName;

          associations = builtins.listToAttrs (
            map
              (name: {
                inherit name value;
              })
              [
                "application/x-extension-shtml"
                "application/x-extension-xhtml"
                "application/x-extension-html"
                "application/x-extension-xht"
                "application/x-extension-htm"
                "x-scheme-handler/unknown"
                "x-scheme-handler/mailto"
                "x-scheme-handler/chrome"
                "x-scheme-handler/about"
                "x-scheme-handler/https"
                "x-scheme-handler/http"
                "application/xhtml+xml"
                "application/json"
                "text/plain"
                "text/html"
              ]
          );
        in
        {
          associations.added = associations;
          defaultApplications = associations;
        };

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
          "${config.home.username}" =
            let
              containers = {
                Life = {
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
                Learning = {
                  color = "blue";
                  icon = "tree";
                  id = 4;
                };
              };
              spaces = {
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
                "Rendezvous" = {
                  id = "572910e1-4468-4832-a869-0b3a93e2f165";
                  icon = "🎭";
                  position = 4000;
                  container = containers.Life.id;
                };
                "Github" = {
                  id = "08be3ada-2398-4e63-bb8e-f8bf9caa8d10";
                  position = 5000;
                  container = containers.Learning.id;
                  icon = "🐙";
                };
                "Nix" = {
                  id = "2441acc9-79b1-4afb-b582-ee88ce554ec0";
                  icon = "❄️";
                  position = 6000;
                  container = containers.Learning.id;

                };
              };
              pins = {
                "mail" = {
                  id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
                  container = containers.Life.id;
                  url = "https://outlook.live.com/mail/";
                  isEssential = true;
                  position = 101;
                };
                "Notion" = {
                  id = "8af62707-0722-4049-9801-bedced343333";
                  container = containers.Life.id;
                  url = "https://notion.com";
                  isEssential = true;
                  position = 102;
                };
                "Folo" = {
                  id = "fb316d70-2b5e-4c46-bf42-f4e82d635153";
                  container = containers.Life.id;
                  url = "https://app.folo.is/";
                  isEssential = true;
                  position = 103;
                };
                "Nix awesome" = {
                  id = "d85a9026-1458-4db6-b115-346746bcc692";
                  workspace = spaces.Nix.id;
                  isGroup = true;
                  isFolderCollapsed = false;
                  editedTitle = true;
                  position = 200;
                };
                "Nix Packages" = {
                  id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
                  workspace = spaces.Nix.id;
                  folderParentId = pins."Nix awesome".id;
                  url = "https://search.nixos.org/packages";
                  position = 201;
                };
                "Nix Options" = {
                  id = "92931d60-fd40-4707-9512-a57b1a6a3919";
                  workspace = spaces.Nix.id;
                  folderParentId = pins."Nix awesome".id;
                  url = "https://search.nixos.org/options";
                  position = 202;
                };
                "Home Manager Options" = {
                  id = "2eed5614-3896-41a1-9d0a-a3283985359b";
                  workspace = spaces.Nix.id;
                  folderParentId = pins."Nix awesome".id;
                  url = "https://home-manager-options.extranix.com";
                  position = 203;
                };
              };
            in
            {
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
                engines = {
                  mynixos = {
                    name = "My NixOS";
                    urls = [
                      {
                        template = "https://mynixos.com/search?q={searchTerms}";
                        params = [
                          {
                            name = "query";
                            value = "searchTerms";
                          }
                        ];
                      }
                    ];

                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = [ "@nx" ]; # Keep in mind that aliases defined here only work if they start with "@"
                  };
                };
              };
              containersForce = true;
              spacesForce = true;
              pinsForce = true;
              inherit containers pins spaces;
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
              extensions.packages = with pkgs.firefoxAddons; [
                # see: https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
                augmented-steam
                # auto-sort-bookmarks
                auto-tab-discard
                # automatic-dark
                # gopass-bridge
                # https-everywhere
                # link-cleaner
                privacy-badger17
                # tree-style-tab
                # multi-account-containers
                # firefox-translations # translation
                kiss-translator
                tridactyl-vim # vimum
                bitwarden-password-manager
                blocktube
                rsshub-radar
                # brotab
                # onetab
                ublock-origin
                # zotero-connector
                copy-as-org-mode
                violentmonkey
                online-dictionary-helper
                tab-session-manager
                auto-tab-discard
              ];
            };
        };
      };
    };
}
