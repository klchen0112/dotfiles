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
    username = "chenkailong_dxm";
    fullname = "chenkailong_dxm";
    email = "chenkailong@duxiaoman.com";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJsUHc8XEf0Pe2acybyO4uEoYu/FrqjX74cYQCuHuR5 klchen@mbp-dxm"
    ];
    base16Scheme = "selenized-light";
  };

  home.stateVersion = "25.05";
}
