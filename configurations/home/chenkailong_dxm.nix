{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = {
    username = "${flake.config}";
    # fullname = "John Doe";
    email = "johndoe@example.com";
  };

  home.stateVersion = "25.05";
}
