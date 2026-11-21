{
  lib,
  den,
  # deadnix: skip # enable <den/brackets> syntax for demo.
  __findFile,
  inputs,
  ...
}:
{
  # 与具体用户无关的 host 基线配置。注意这里**不要**写「假定某个 host 有某个用户」
  # 的内容（例如 klchen 的 AllowUsers / trusted-users / authorizedKeys）：
  # 那些放在 `den.aspects.<user>.provides.to-hosts`（见 modules/users/klchen.nix），
  # 只会落到真正有这个用户的 host 上。
  den.default.nixos = {
    system.stateVersion = "26.05";
    programs.dconf.enable = true;
    time.timeZone = "Asia/Shanghai";
    imports = [
      inputs.disko.nixosModules.disko
    ];
    boot.loader.systemd-boot.enable = true;
    users.mutableUsers = false;
    services.openssh = {
      enable = true;
      authorizedKeysInHomedir = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
        AllowUsers = [ "root" ];
      };
    };
    #  zramSwap.enable = true;
    # `home-manager.backupFileExtension` 这里不能写：没有任何 HM 用户的 host 上
    # `home-manager` 这个 option 根本不存在（`mkIf` 也救不了，option 不存在就是错）。
    # 它跟着“有 HM 用户”的投递走，见 modules/users/klchen.nix 的 provides.to-hosts。
    nixpkgs.overlays = [
      # Use nixpkgs from your environment, nixpkgs.config will apply.
      # Has small chance of kernel modules not being compatible with kernel version.
      inputs.nix-cachyos-kernel.overlays.pinned
      inputs.self.overlays.default
    ];
  };

  den.default.homeManager = {
    home.stateVersion = "26.05";
  };
  den.default.darwin = {
    system.stateVersion = 6;
    home-manager.users.klchen.home.homeDirectory = "/Users/klchen";
  };
  # These are functions that produce configs
  den.default.includes = [
    # ${user}.provides.${host} and ${host}.provides.${user}
    <den/mutual-provider>

    # Automatically set hostname
    <den/hostname>

    # Automatically create the user on host.
    # <den/define-user>
  ];
  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
