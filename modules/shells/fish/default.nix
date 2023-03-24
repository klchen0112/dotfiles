#
# fish configuration
#
{
  pkgs,
  pkgs-unstable,
  ...
}: {
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
        conda = "micromamba";
      };

      # issue from https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /opt/homebrew/bin
                        # # >>> mamba initialize >>>
                        # # !! Contents within this block are managed by 'mamba init' !!
                        # set -gx MAMBA_EXE \"$HOME/.nix-profile/bin/micromamba\"
                        # set -gx MAMBA_ROOT_PREFIX \"$HOME/micromamba\"
                        # eval \"$HOME/.nix-profile/bin/micromamba\" shell hook --shell fish --prefix \"$HOME/micromamba\" | source
                        # # <<< mamba initialize <<<
                        ";

      plugins = with pkgs; [
        {
          name = "z";
          src =
            pkgs.fetchFromGitHub
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
    fzf
    shfmt
    tmux
    fish
  ];
}
