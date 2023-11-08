#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{ config
, pkgs
, username
, system
, inputs
, ...
}: {

  programs.fish = {
    enable = true;
  };

  environment = {
    shells = with pkgs; [ fish bash ]; # Default shell
    systemPackages = with pkgs; [
      # Installed Nix packages
      gnumake
    ];
  };

  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    allowSFTP = true;
  };


}
