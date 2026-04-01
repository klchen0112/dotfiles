{ inputs, ... }:
{
  den.aspects.nix = {

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          nixfmt
          nix-du
          nixd
          cachix
          # statix
          # deadnix
          nix-fast-build
          devenv
        ];
        nixpkgs.overlays = [
          #  inputs.emacs-overlay.overlays.default
          inputs.nix-vscode-extensions.overlays.default
          # inputs.self.overlays.default
        ];

      };
    nixos = {

      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
      programs.nix-ld.enable = true;
      nixpkgs.overlays = [
        #        inputs.emacs-overlay.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        inputs.firefox-addons.overlays.default
        # inputs.self.overlays.default
      ];
    };
    darwin = {

      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

      nixpkgs.overlays = [
        #       inputs.emacs-overlay.overlays.default
        inputs.firefox-addons.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        # inputs.self.overlays.default
      ];
    };
  };
}
