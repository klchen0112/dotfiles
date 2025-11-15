{ inputs, ... }:
{
  flake.modules.homeManager.nix =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixfmt-rfc-style
        # nixfmt
        # nix-du
        nil
        # cachix
        # statix
        # deadnix
        # nix-fast-build
        # devenv
      ];
      nixpkgs.overlays = [
        #  inputs.emacs-overlay.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        inputs.self.overlays.default
      ];

    };
  flake.modules.nixos.nix =
    {
      ...
    }:
    {

      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

      nixpkgs.overlays = [
        #        inputs.emacs-overlay.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        inputs.self.overlays.default
      ];
    };
  flake.modules.darwin.nix =
    {
      ...
    }:
    {

      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

      nixpkgs.overlays = [
        #       inputs.emacs-overlay.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        inputs.self.overlays.default
      ];
    };
}
