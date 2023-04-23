#
# fish configuration
#
{pkgs, ...}: {
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
        # conda = "micromamba";
      };
      shellAliases = {
        # conda = "micromamba";
        "..." = "cd ../..";
      };

      # issue from https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit = ''fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /opt/homebrew/bin
                        #>>> conda initialize >>>
                        # !! Contents within this block are managed by 'conda init' !!
                        eval /opt/homebrew/bin/conda "shell.fish" "hook" $argv | source
                        # <<< conda initialize <<<
                        '';
      plugins = with pkgs.fishPlugins; [
        {
          name = "z";
          src = z;
        }
        {
          name = "fzf-fish";
          src = fzf-fish;
        }
        {
          name = "colored-man-pages";
          src = colored-man-pages;
        }
        {
          name = "autopair";
          src = autopair-fish;
        }
        # {
        #   name = "tide";
        #   src = tide;
        # }
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
  ];
}
