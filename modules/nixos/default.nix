{ inputs, ... }:
{
  flake.modules.nixos.nixos = {
    services.openssh.enable = true;
    imports = with inputs.self.modules.nixos; [
      network
    ];
    time.timeZone = "Asia/Shanghai";
  };
}
