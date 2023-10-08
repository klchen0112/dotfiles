# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ inputs, pkgs }: {
  # example = pkgs.callPackage ./example { };
  sf-pro = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
  sf-pro-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;

  sf-compact = inputs.apple-fonts.packages.${pkgs.system}.sf-compact;
  sf-compact-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-compact-nerd;

  sf-mono = inputs.apple-fonts.packages.${pkgs.system}.sf-mono;
  sf-mono-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd;

  sf-arabic = inputs.apple-fonts.packages.${pkgs.system}.sf-arabic;
  sf-arabic-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-arabic-nerd;

  ny = inputs.apple-fonts.packages.${pkgs.system}.ny;
  ny-nerd = inputs.apple-fonts.packages.${pkgs.system}.ny-nerd;

}
