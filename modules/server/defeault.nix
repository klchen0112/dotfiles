{
  den.aspects.server.nixos =
    { inputs }:
    {
      imports = [
        inputs.srvos.nixosModules.server
      ];
    };
}
