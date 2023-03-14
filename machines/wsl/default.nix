#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{
  config,
  pkgs,
  user,
  ...
}: {
  hardware.opengl.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
    fish
    coreutils\
  ];
  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.fish; # Default shell
    isNormalUser = true;
    extraGroups = ["whell"];
  };
}
