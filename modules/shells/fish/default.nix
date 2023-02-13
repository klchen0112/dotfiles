#
# fish configuration
#

{ config, lib, pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
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
      loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /opt/homebrew/bin";

      plugins = with pkgs; [
        {
          name = "z";
          src = pkgs.fetchFromGitHub
            {
              owner = "jethrokuan";
              repo = "z";
              rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
              sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
            };
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair-fish) src;
        }
      ];
    };
  };
  home.packages = with pkgs; [
    exa
    ripgrep
    bat
    tmux
    fish
    starship
  ];
  programs.starship.enableFishIntegration = true;

}
