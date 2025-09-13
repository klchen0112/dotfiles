let
  cfg = {
    # Garbage collect the Nix store
    nix.gc = {
      automatic = true;
      # Change how often the garbage collector runs (default: weekly)
      # frequency = "monthly";
    };
  };
in
{
  flake.modules.homeManager.nix = cfg;
  flake.modules.darwin.nix = cfg;
  flake.modules.nixos.nix = cfg;

}
