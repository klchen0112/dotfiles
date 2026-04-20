{
  den,
  inputs,
  # deadnix: skip # enable <den/brackets> syntax for demo.
  __findFile,
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
    {
      user = {
        createHome = true;
        openssh.authorizedKeys.keys = keys;
      };
      nixos = {
        services.openssh.settings.AllowUsers = [ "klchen" ];
        users.users.root.openssh.authorizedKeys.keys = keys;
        users.users.klchen.isNormalUser = true;
        programs.bash.enable = true;
        users.users.klchen = {
          initialHashedPassword = "$y$j9T$WX1yl8edHz32y77s640GV.$M1U0keGszxKa9efTMnTG/VJAIOqtDj0mPEToL6cBF13";
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
      os = {
        nix.settings.trusted-users = [ "klchen" ];
      };
      homeManager =
        { pkgs, lib, ... }:
        {
          nixpkgs.overlays = [
            inputs.self.overlays.default
          ];
          nixpkgs.config.allowUnfree = true;
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

        <den/define-user>
        <den/primary-user>
        #      (den.provides.user-shell "nu")
      ]
      ++ [
        # <hmPlatforms>
        <stylix-home>
        <python>
        <java>
        <nushell>
        <bash>
        <zsh>
        <starship>
        <utils>
        <git>
        <kitty>
        <ssh>
        <nix-index>
        <nix-home>
        <emacs-twist>
        <vscode>
        <noctalia-shell>
        <niri-home>
        <ghostty>
        <zen>
        <paneru>
        <llm>
        <inputmethod>
        <k8s>
        <syncthing>
        <font-home>
        <aria2>
      ];
    };

}
