{ config, pkgs, lib, inputs, system, flake, rosettaPkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    fd
    bat
    fish
    wget
    ripgrep
    sd
    pandoc
    tree-sitter
    # nodejs
    nodejs # Required for VSCode's webhint extension
    # for python
    nodePackages.pyright
    python39
    python39Packages.pip
    inputs.mach-nix.packages.${system}.mach-nix
    # python39Packages.torch
    # python310Packages.conda
    fontconfig
    wakatime
    nil
    gh
    nixpkgs-fmt
    exa
    inputs.hci.packages.${system}.hercules-ci-cli
    inputs.nixpkgs-match.packages.${system}.default


  ];
  environment.shells = with pkgs ; [ fish ];
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes repl-flake
    '';
    # https://nixos.wiki/wiki/Distributed_build
    # distributedBuilds = true;
    # buildMachines = [
    #  {
    #    hostName = (import ./hetzner/ax41.info.nix).publicIP;
    #    system = "x86_64-linux";
    #    maxJobs = 10;
    #  }
    # ];
    settings = {
      max-jobs = 8;
      cores = 8;
    };

  };
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;

  security.pam.enableSudoTouchIdAuth = true;

  # For home-manager to work.
  users.users.${flake.config.people.myself} = {
    name = flake.config.people.myself;
    home = "/Users/${flake.config.people.myself}";
    shell = pkgs.fish;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.emacs.package = inputs.emacs-overlay.packages.${system}.emacsGit;
  services.emacs.enable = true;
  #
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
