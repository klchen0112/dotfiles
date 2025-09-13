{
  flake.modules.homeManager.nushell =
    {
      pkgs,
      ...
    }:
    let
      nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";
    in
    {
      stylix.targets.nushell.enable = true;
      programs.starship.enableNushellIntegration = true;
      home.shellAliases = {
        # ls = "exa";
        ll = "exa -lha";
        lt = "exa --tree";
        htop = "btop";
        # psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
        e = "emacsclient -nc";
        E = "emacs -nw";
        grep = "rg";
        cat = "bat";
        conda = "mamba";
        vim = "emacs -nw";
        "..." = "cd ../..";
        "j" = "just";
        "cd" = "z";
      };
      programs.nushell = {
        enable = true;
        settings = {
          completions.external = {
            enable = true;
            max_results = 200;
          };
          show_banner = false;
        };
        #envFile.text = ''
        #  $env.PATH = ["/etc/profiles/per-user/${config.home.username}/bin" "/nix/var/nix/profiles/system/sw/bin" "${config.home.homeDirectory}/.nix-profile/bin" "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin" "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin"]
        #  if ($nu.os-info.name == 'mac') {
        #    $env.PATH ++= ["/opt/homebrew/bin" "/opt/homebrew/sbin"]
        #  }
        #'';
        plugins = with pkgs.nushellPlugins; [
          polars
          # highlight
          query
          gstat
        ];
        extraConfig = ''
          use ${nu_scripts}/modules/nix/nix.nu *

          # completions
          use ${nu_scripts}/custom-completions/uv/uv-completions.nu *
          use ${nu_scripts}/custom-completions/git/git-completions.nu *
          use ${nu_scripts}/custom-completions/just/just-completions.nu *
          use ${nu_scripts}/custom-completions/nix/nix-completions.nu *
          use ${nu_scripts}/custom-completions/ssh/ssh-completions.nu *
          use ${nu_scripts}/custom-completions/eza/eza-completions.nu *
          use ${nu_scripts}/custom-completions/bat/bat-completions.nu *
        '';
      };
    };
}
