{
  flake-file.inputs = {
    nixpkgs.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable"; # Nix Packages
    nixpkgs-unstable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable-small"; # Nix Packages
    nixpkgs-stable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-25.05"; # Nix Packages

  };
  flake.modules.homeManager.nix =
    { pkgs, ... }:
    {
      imports = [
        ./gc.nix
        ./caches.nix
        ./nix.nix
      ];
      home.packages = with pkgs; [
        nixfmt-rfc-style
        # nixfmt
        # nix-du
        nil
        cachix
        statix
        deadnix
        nix-fast-build
        devenv
      ];

    };
  flake.modules.nixos.nix =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [
        ./gc.nix
        ./caches.nix
        ./nix.nix
      ];

      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
        # flake.inputs.self.overlays.default
      ]
      ++ (lib.attrValues inputs.self.overlays);
    };
}
