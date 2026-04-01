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
  den.aspects.nix = {
    homeManager = cfg;
    darwin = cfg;
    nixos = cfg;
  };

}
