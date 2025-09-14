{
  flake.modules.nixos.server =
    { inputs }:
    {
      imports = [
        inputs.srvos.nixosModules.server
      ];
    };
}
