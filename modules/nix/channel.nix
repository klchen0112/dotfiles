{ inputs, ... }:
{

  den.aspects.nix =
    let
      cfg = {
        nix.channel.enable = false;
        environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
      };
    in
    {

      darwin = cfg;
      nixos = cfg;
    };
}
