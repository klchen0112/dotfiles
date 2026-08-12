{ den, inputs, ... }: {
  flake-file.inputs = {
    fast-nix-gc = {
      url = "github:Mic92/fast-nix-gc";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "darwin";
    };

  };
  den.aspects.nix-home = {
    homeManager = {
      nix.gc = {
        automatic = false;
      };
    };
  };
  den.aspects.nix = {

    darwin = {
      imports = [
        inputs.fast-nix-gc.darwinModules.default
      ];
      services.fast-nix-gc = {
        enable = true;
        automatic = true;
        startCalendarInterval = [
          {
            Hour = 3;
            Minute = 15;
          }
        ];
        deleteOlderThan = "30d";
        ensureFree = "50G";
      };

    };
    nixos = {
      imports = [
        inputs.fast-nix-gc.nixosModules.default
      ];
      services.fast-nix-gc = {
        enable = true;
        automatic = true;
        dates = "weekly";
        deleteOlderThan = "30d";
        ensureFree = "50G";
        keepRecent = "1d";
      };
      services.fast-nix-optimise = {
        enable = true;
        automatic = true;
        dates = "weekly";
      };
    };
  };

}
