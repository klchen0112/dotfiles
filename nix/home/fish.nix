{ pkgs, config, lib, ... }:

{
  # home.file.".bashrc" = lib.mkIf config.programs.fish.enable {
  #   text = ''
  #       exec ${config.programs.fish.package}/bin/fish
  #   '';
  # };

  programs.fish = {
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      lt = "exa --tree";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      E = "sudoedit";
      grep = "rg";
      cat = "bat";
    };

    # issue from https://github.com/LnL7/nix-darwin/issues/122
    loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";

    plugins = with pkgs ;[
      { name = "tide"; src = fishPlugins.tide.src; }
      {
        name = "z";
        src = pkgs.fetchFromGitHub
          {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
      }
    ];
  };
}

