{ den, inputs, ... }: {
  den.aspects.btrfs-scrub = {
    nixos = {
      services.btrfs = {
        autoScrub.enable = true;
        autoScrub.interval = "weekly";
      };
    };
  };
}
