{ self, inputs, config, ... }:
{
  # Configuration common to all macOS systems
  flake = {
    darwinModules = {
      myself = {
        home-manager.users.${config.people.myself} = { pkgs, ... }: {
          imports = [
            self.homeModules.common-darwin
            ../home/git.nix
            ../home/fish.nix
          ];
        };
      };
      default.imports = [
        self.darwinModules.home-manager
        self.darwinModules.myself
        ../nixos/caches
        ../home/fonts.nix
        ../home/homebrew.nix
      ];
    };

  };
}
