{
  pkgs,
  flake,
  config,
  ...
}:
{
  imports = [
    flake.inputs.niri.nixosModules.niri
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      };
    };
  };
  # polkit agent
  security.soteria.enable = true;

  # 磁盘挂载
  services.gvfs.enable = true;

  # 压缩解压
  programs.file-roller.enable = true;

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  nixpkgs.overlays = [
    flake.inputs.niri.overlays.niri
  ];
  nix.settings = {
    # add binary caches
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "https://walker.cachix.org"
    ];
    substituters = [
      "https://niri.cachix.org"
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };
}
