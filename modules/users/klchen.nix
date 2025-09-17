{ config, inputs, ... }:
{
  flake.meta.users.klchen = {
    username = "klchen";
    fullname = "klchen0112";
    email = "klchen0112@gmail.com";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPI6HctaCnuhyOdbrYs2un7/QA/hqFPfDVRlL0klfhGc klchen@i12r20"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNgI2fAHSDQCB+DgZPsjGF+arPudVmWS4hTXbJCvwwX klchen@a99r50"
    ];
    base16Scheme = "selenized-dark";
    initialHashedPassword = "$6$qpLfyxefL6ImN6y8$6P2BYZEfmjdh6LeL4646LEhZnORcyxWIRxRBN2Nt6XGLk7pTu6XBy4u.mkpUs2pLW28kFx6dks8SNW2OW0AKf1";
  };
  flake.modules.homeManager.klchen =
    { pkgs, lib, ... }:
    {
      home.username = lib.mkDefault " klchen";
      home.homeDirectory = lib.mkDefault (
        if pkgs.stdenvNoCC.isDarwin then "/Users/klchen" else "/home/klchen"
      );
      home.stateVersion = lib.mkDefault "25.05";
      imports = with inputs.self.modules.homeManager; [
        nushell
        nix
        stylix
        starship
        utils
        git
        utils
        ssh
        python
        nix-index
      ];
    };

  flake.modules.nixos.klchen =
    { pkgs, ... }:
    {
      home-manager.users.klchen.imports = with inputs.self.modules.homeManager; [ klchen ];
      nix.settings.trusted-users = [ config.flake.meta.users.klchen.username ];
      users.users.klchen = {
        description = config.flake.meta.users.klchen.fullname;
        isNormalUser = true;
        createHome = true;
        extraGroups = [
          "audio"
          "input"
          "networkmanager"
          "sound"
          "tty"
          "wheel"
        ];
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = config.flake.meta.users.klchen.authorizedKeys;
        initialHashedPassword = config.flake.meta.users.klchen.initialHashedPassword;
      };
      users.users.root.openssh.authorizedKeys.keys = config.flake.meta.users.klchen.authorizedKeys;
    };
  flake.modules.darwin.klchen =
    { lib, ... }:
    {
      home-manager.users.klchen.imports = with inputs.self.modules.homeManager; [ klchen ];
      home-manager.users.klchen.home.homeDirectory = lib.mkForce "/Users/klchen";
      users.users.klchen = {
        name = config.flake.meta.users.klchen.username;
      };
      programs.zsh.enable = true;
      nix.settings.trusted-users = [ config.flake.meta.users.klchen.username ];
    };
}
