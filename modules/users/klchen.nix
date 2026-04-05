{
  den,
  inputs,
  ...
}:
{
  den.aspects.klchen =
    let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPI6HctaCnuhyOdbrYs2un7/QA/hqFPfDVRlL0klfhGc klchen@i12r20"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNgI2fAHSDQCB+DgZPsjGF+arPudVmWS4hTXbJCvwwX klchen@a99r50"
      ];
    in
    { lib, pkgs, ... }:
    {
      user = {

        createHome = true;

        openssh.authorizedKeys.keys = keys;
      };
      nixos = {
        services.openssh.settings.AllowUsers = [ "klchen" ];
        users.users.root.openssh.authorizedKeys.keys = keys;
        nix.settings.trusted-users = [ "klchen" ];
        users.users.klchen = {
          initialHashedPassword = "$y$j9T$WX1yl8edHz32y77s640GV.$M1U0keGszxKa9efTMnTG/VJAIOqtDj0mPEToL6cBF13";
          isNormalUser = true;
          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "sound"
            "tty"
            "wheel"
          ];
        };
      };
      hmLinux = {
        programs.bash.enable = true;
      };
      hmLinux = {
        programs.zsh.enable = true;
      };
      darwin = {
        programs.zsh.enable = true;
      };
      homeManager =
        { pkgs, lib, ... }:
        {
          nix.settings.trusted-users = [ "klchen" ];
          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
          home.username = lib.mkDefault " klchen";
          home.homeDirectory = lib.mkForce (
            if pkgs.stdenvNoCC.isDarwin then "/Users/klchen" else "/home/klchen"
          );

          programs.git.settings.user = {

            name = "klchen0112";
            email = "klchen0112@gmail.com";

          };

        };
      includes = [
        den.provides.primary-user
        #      (den.provides.user-shell "nu")
      ]
      ++ (with den.aspects; [
        nix
        python
        nushell
        bash
        stylix-home
        starship
        utils
        git
        ssh
        nix-index
        font
        emacs-twist
        noctalia-shell
        niri-home
        ghostty
        zen
        paneru
        llm
      ]);
    };

}
