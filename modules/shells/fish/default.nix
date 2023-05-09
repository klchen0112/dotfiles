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
      interactiveShellInit = ''
        set -Ux _tide_left_items os pwd git newline character
        set -Ux _tide_right_items status cmd_duration context jobs virtual_env
        set -Ux tide_aws_bg_color normal
        set -Ux tide_aws_color FF9900
        set -Ux tide_aws_icon \uf270
        set -Ux tide_character_color 5FD700
        set -Ux tide_character_color_failure FF0000
        set -Ux tide_character_icon \u276f
        set -Ux tide_character_vi_icon_default \u276e
        set -Ux tide_character_vi_icon_replace \u25b6
        set -Ux tide_character_vi_icon_visual V
        set -Ux tide_chruby_bg_color normal
        set -Ux tide_chruby_color B31209
        set -Ux tide_chruby_icon \ue23e
        set -Ux tide_cmd_duration_bg_color normal
        set -Ux tide_cmd_duration_color 87875F
        set -Ux tide_cmd_duration_decimals 0
        set -Ux tide_cmd_duration_icon \uf252
        set -Ux tide_cmd_duration_threshold 3000
        set -Ux tide_context_always_display false
        set -Ux tide_context_bg_color normal
        set -Ux tide_context_color_default D7AF87
        set -Ux tide_context_color_root D7AF00
        set -Ux tide_context_color_ssh D7AF87
        set -Ux tide_context_hostname_parts 1
        set -Ux tide_crystal_bg_color normal
        set -Ux tide_crystal_color FFFFFF
        set -Ux tide_crystal_icon \u2b22
        set -Ux tide_docker_bg_color normal
        set -Ux tide_docker_color 2496ED
        set -Ux tide_docker_default_contexts default colima
        set -Ux tide_docker_icon \uf308
        set -Ux tide_git_bg_color normal
        set -Ux tide_git_bg_color_unstable normal
        set -Ux tide_git_bg_color_urgent normal
        set -Ux tide_git_color_branch 5FD700
        set -Ux tide_git_color_conflicted FF0000
        set -Ux tide_git_color_dirty D7AF00
        set -Ux tide_git_color_operation FF0000
        set -Ux tide_git_color_staged D7AF00
        set -Ux tide_git_color_stash 5FD700
        set -Ux tide_git_color_untracked 00AFFF
        set -Ux tide_git_color_upstream 5FD700
        set -Ux tide_git_icon \uf1d3
        set -Ux tide_git_truncation_length 24
        set -Ux tide_go_bg_color normal
        set -Ux tide_go_color 00ACD7
        set -Ux tide_go_icon \ue627
        set -Ux tide_java_bg_color normal
        set -Ux tide_java_color ED8B00
        set -Ux tide_java_icon \ue256
        set -Ux tide_jobs_bg_color normal
        set -Ux tide_jobs_color 5FAF00
        set -Ux tide_jobs_icon \uf013
        set -Ux tide_kubectl_bg_color normal
        set -Ux tide_kubectl_color 326CE5
        set -Ux tide_kubectl_icon \u2388
        set -Ux tide_left_prompt_frame_enabled false
        set -Ux tide_left_prompt_items os pwd git newline character
        set -Ux tide_left_prompt_prefix
        set -Ux tide_left_prompt_separator_diff_color \x20
        set -Ux tide_left_prompt_separator_same_color \x20
        set -Ux tide_left_prompt_suffix \x20
        set -Ux tide_nix_shell_bg_color normal
        set -Ux tide_nix_shell_color 7EBAE4
        set -Ux tide_nix_shell_icon \uf313
        set -Ux tide_node_bg_color normal
        set -Ux tide_node_color 44883E
        set -Ux tide_node_icon \u2b22
        set -Ux tide_os_bg_color normal
        set -Ux tide_os_color normal
        set -Ux tide_os_icon \uf31b
        set -Ux tide_php_bg_color normal
        set -Ux tide_php_color 617CBE
        set -Ux tide_php_icon \ue608
        set -Ux tide_private_mode_bg_color normal
        set -Ux tide_private_mode_color FFFFFF
        set -Ux tide_private_mode_icon \ufaf8
        set -Ux tide_prompt_add_newline_before true
        set -Ux tide_prompt_color_frame_and_connection 6C6C6C
        set -Ux tide_prompt_color_separator_same_color 949494
        set -Ux tide_prompt_icon_connection \u00b7
        set -Ux tide_prompt_min_cols 34
        set -Ux tide_prompt_pad_items false
        set -Ux tide_pwd_bg_color normal
        set -Ux tide_pwd_color_anchors 00AFFF
        set -Ux tide_pwd_color_dirs 0087AF
        set -Ux tide_pwd_color_truncated_dirs 8787AF
        set -Ux tide_pwd_icon \uf07c
        set -Ux tide_pwd_icon_home \uf015
        set -Ux tide_pwd_icon_unwritable \uf023
        set -Ux tide_pwd_markers \x2ebzr \x2ecitc \x2egit \x2ehg \x2enode\x2dversion \x2epython\x2dversion \x2eruby\x2dversion \x2eshorten_folder_marker \x2esvn \x2eterraform Cargo\x2etoml composer\x2ejson CVS go\x2emod package\x2ejson
        set -Ux tide_right_prompt_frame_enabled false
        set -Ux tide_right_prompt_items status cmd_duration context jobs node virtual_env rustc java php chruby go kubectl toolbox terraform aws nix_shell crystal
        set -Ux tide_right_prompt_prefix \x20
        set -Ux tide_right_prompt_separator_diff_color \x20
        set -Ux tide_right_prompt_separator_same_color \x20
        set -Ux tide_right_prompt_suffix
        set -Ux tide_rustc_bg_color normal
        set -Ux tide_rustc_color F74C00
        set -Ux tide_rustc_icon \ue7a8
        set -Ux tide_shlvl_bg_color normal
        set -Ux tide_shlvl_color d78700
        set -Ux tide_shlvl_icon \uf120
        set -Ux tide_shlvl_threshold 1
        set -Ux tide_status_bg_color normal
        set -Ux tide_status_bg_color_failure normal
        set -Ux tide_status_color 5FAF00
        set -Ux tide_status_color_failure D70000
        set -Ux tide_status_icon \u2714
        set -Ux tide_status_icon_failure \u2718
        set -Ux tide_terraform_bg_color normal
        set -Ux tide_terraform_color 844FBA
        set -Ux tide_terraform_icon \x1d
        set -Ux tide_time_bg_color normal
        set -Ux tide_time_color 5F8787
        set -Ux tide_time_format
        set -Ux tide_toolbox_bg_color normal
        set -Ux tide_toolbox_color 613583
        set -Ux tide_toolbox_icon \u2b22
        set -Ux tide_vi_mode_bg_color_default normal
        set -Ux tide_vi_mode_bg_color_insert normal
        set -Ux tide_vi_mode_bg_color_replace normal
        set -Ux tide_vi_mode_bg_color_visual normal
        set -Ux tide_vi_mode_color_default 949494
        set -Ux tide_vi_mode_color_insert 87AFAF
        set -Ux tide_vi_mode_color_replace 87AF87
        set -Ux tide_vi_mode_color_visual FF8700
        set -Ux tide_vi_mode_icon_default D
        set -Ux tide_vi_mode_icon_insert I
        set -Ux tide_vi_mode_icon_replace R
        set -Ux tide_vi_mode_icon_visual V
        set -Ux tide_virtual_env_bg_color normal
        set -Ux tide_virtual_env_color 00AFAF
        set -Ux tide_virtual_env_icon \ue73c
      '';
      # issue from https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit = ''        fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /opt/homebrew/bin
                                 #>>> conda initialize >>>
                                 # !! Contents within this block are managed by 'conda init' !!
                                 eval /opt/homebrew/bin/conda "shell.fish" "hook" $argv | source
                                 # <<< conda initialize <<<
      '';
      plugins = with pkgs.fishPlugins; [
        {
          name = "z";
          src = z.src;
        }
        {
          name = "fzf-fish";
          src = fzf-fish.src;
        }
        {
          name = "colored-man-pages";
          src = colored-man-pages.src;
        }
        # {
        #   name = "async-prompt";
        #   src = async-prompt.src;
        # }
        {
          name = "autopair";
          src = autopair-fish.src;
        }
        {
          name = "tide";
          src = tide.src;
        }
        {
          name = "sponge";
          src = sponge.src;
        }
      ];
    };
  };
  home.packages = with pkgs; [
    exa
    ripgrep
    bat
    fzf
    tmux
  ];
}
