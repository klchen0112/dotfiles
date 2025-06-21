{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.nix4nvchad.homeManagerModule
  ];
  programs = {
    nvchad = {
      enable = true;
      extraPackages = with pkgs; [
        nixd
      ];
      hm-activation = true;
      backup = true;
    };
  };
}
