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
    username = "klchen";
    fullname = "klchen0112";
    email = "klchen0112@gmail.com";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB038WYBDH0cCGTeLWDLXZIxXinpLk5oICCpW4UlW3Oz klchen@i12r70"
    ];
    base16Scheme = "selenized-light";
  };

  home.stateVersion = "25.05";
}
