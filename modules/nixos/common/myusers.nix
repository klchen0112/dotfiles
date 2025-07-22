# List of users for darwin or nixos system and their top-level configuration.
{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  machineSubmodule = lib.types.submodule {
    options = {
      hostName = lib.mkOption {
        type = lib.types.str;
      };
      platform = lib.mkOption {
        type = lib.types.str;
      };
      base16Scheme = lib.mkOption {
        type = lib.types.str;
      };
      sshKey = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          SSH public key
        '';
      };
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          list of user
        '';
      };
      desktop = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  inherit (flake.inputs) self;
  mapListToAttrs =
    m: f:
    lib.listToAttrs (
      map (name: {
        inherit name;
        value = f name;
      }) m
    );
in
{
  options = {
    myusers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of usernames";
      defaultText = "All users under ./configuration/users are included by default";
      default =
        let
          dirContents = builtins.readDir (self + /configurations/home);
          fileNames = builtins.attrNames dirContents; # Extracts keys: [ "klchen.nix" ]
          regularFiles = builtins.filter (name: dirContents.${name} == "regular") fileNames; # Filters for regular files
          baseNames = map (name: builtins.replaceStrings [ ".nix" ] [ "" ] name) regularFiles; # Removes .nix extension
        in
        baseNames;
    };
    machine = lib.mkOption {
      type = machineSubmodule;
    };
  };
  config = {
    # For home-manager to work.
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users =
      mapListToAttrs config.myusers (
        name:
        let
          userConfig = flake.config.users.${name};
        in
        lib.optionalAttrs pkgs.stdenv.isDarwin {
          home = "/Users/${name}";
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          initialHashedPassword = userConfig.initialHashedPassword;

        }
        // {
          openssh.authorizedKeys.keys = userConfig.sshKey;
        }
      )
      // {
        root =
          let
            rootSshKeys = map (user: flake.config.users.${user}.sshKey) (
              builtins.filter (user: flake.config.users.${user}.root == true) config.myusers
            );
          in
          {
            openssh.authorizedKeys.keys = builtins.concatLists rootSshKeys;
          };
      };
    home-manager.backupFileExtension = "nixos-unified-template-backup";
    # Enable home-manager for our user
    home-manager.users = mapListToAttrs config.myusers (name: {
      imports =
        [ (self + /configurations/home/${name}.nix) ]
        ++ (lib.optionals pkgs.stdenv.isLinux [
          (self + /modules/home/bash)
        ])
        ++ (lib.optionals pkgs.stdenv.isDarwin [
          (self + /modules/home/zsh)
        ])
        ++ (lib.optionals config.machine.desktop [
          (self + /modules/home/desktop.nix)
        ])
        ++ (lib.optionals (config.machine.desktop && pkgs.stdenv.isLinux) [
          (self + /modules/home/desktop-linux.nix)
        ])
        ++ (lib.optionals (config.machine.desktop && pkgs.stdenv.isDarwin) [
          (self + /modules/home/desktop-darwin.nix)
        ]);
      nix.settings.trusted-users = [
        "root"
        "@wheel"
        "${name}"
      ];
    });

    # All users can add Nix caches.
    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ] ++ config.myusers;
  };
}
