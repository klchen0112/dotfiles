{
  pkgs,
  ...
}:
let
  nu_scripts =  "${pkgs.nu_scripts}/share/nu_scripts";
in
{
  stylix.targets.nushell.enable = true;
  programs.nushell = {
    enable = true;
    settings = {
      completions.external = {
        enable = true;
        max_results = 200;
      };
    };
    extraConfig = ''
      use ${nu_scripts}/modules/nix/nix.nu *

       # completions
      use ${nu_scripts}/custom-completions/uv/uv-completions.nu *
    '';
  };
}
