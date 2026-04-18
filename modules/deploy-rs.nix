{ inputs, ... }:
let

  mkNode =
    name: cfg:
    let
      inherit (cfg.pkgs.stdenv.hostPlatform) system;
      deployLib = inputs.deploy-rs.lib.${system};
    in
    {
      hostname = "${name}.klchen.duckdns.org";
      sshUser = "root";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos cfg;
      };
    };
in
{
  flake.deploy = {
    nodes = {
      a99r50 = mkNode "a99r50" inputs.self.nixosConfigurations.a99r50;
      sanjiao = mkNode "sanjiao" inputs.self.nixosConfigurations.sanjiao;
      i12400 = mkNode "i12400" inputs.self.nixosConfigurations.i12400;
      a2700 = mkNode "a2700" inputs.self.nixosConfigurations.a2700;
    };
  };

}
