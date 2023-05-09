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

        set -gx _tide_left_items:os\x1epwd\x1egit\x1enewline\x1echaracter
        set -gx _tide_right_items:status\x1ecmd_duration\x1econtext\x1ejobs\x1evirtual_env
        set -gx tide_aws_bg_color:normal
        set -gx tide_aws_color:FF9900
        set -gx tide_aws_icon:\uf270
        set -gx tide_character_color:5FD700
        set -gx tide_character_color_failure:FF0000
        set -gx tide_character_icon:\u276f
        set -gx tide_character_vi_icon_default:\u276e
        set -gx tide_character_vi_icon_replace:\u25b6
        set -gx tide_character_vi_icon_visual:V
        set -gx tide_chruby_bg_color:normal
        set -gx tide_chruby_color:B31209
        set -gx tide_chruby_icon:\ue23e
        set -gx tide_cmd_duration_bg_color:normal
        set -gx tide_cmd_duration_color:87875F
        set -gx tide_cmd_duration_decimals:0
        set -gx tide_cmd_duration_icon:\uf252
        set -gx tide_cmd_duration_threshold:3000
        set -gx tide_context_always_display:false
        set -gx tide_context_bg_color:normal
        set -gx tide_context_color_default:D7AF87
        set -gx tide_context_color_root:D7AF00
        set -gx tide_context_color_ssh:D7AF87
        set -gx tide_context_hostname_parts:1
        set -gx tide_crystal_bg_color:normal
        set -gx tide_crystal_color:FFFFFF
        set -gx tide_crystal_icon:\u2b22
        set -gx tide_docker_bg_color:normal
        set -gx tide_docker_color:2496ED
        set -gx tide_docker_default_contexts:default\x1ecolima
        set -gx tide_docker_icon:\uf308
        set -gx tide_git_bg_color:normal
        set -gx tide_git_bg_color_unstable:normal
        set -gx tide_git_bg_color_urgent:normal
        set -gx tide_git_color_branch:5FD700
        set -gx tide_git_color_conflicted:FF0000
        set -gx tide_git_color_dirty:D7AF00
        set -gx tide_git_color_operation:FF0000
        set -gx tide_git_color_staged:D7AF00
        set -gx tide_git_color_stash:5FD700
        set -gx tide_git_color_untracked:00AFFF
        set -gx tide_git_color_upstream:5FD700
        set -gx tide_git_icon:\uf1d3
        set -gx tide_git_truncation_length:24
        set -gx tide_go_bg_color:normal
        set -gx tide_go_color:00ACD7
        set -gx tide_go_icon:\ue627
        set -gx tide_java_bg_color:normal
        set -gx tide_java_color:ED8B00
        set -gx tide_java_icon:\ue256
        set -gx tide_jobs_bg_color:normal
        set -gx tide_jobs_color:5FAF00
        set -gx tide_jobs_icon:\uf013
        set -gx tide_kubectl_bg_color:normal
        set -gx tide_kubectl_color:326CE5
        set -gx tide_kubectl_icon:\u2388
        set -gx tide_left_prompt_frame_enabled:false
        set -gx tide_left_prompt_items:os\x1epwd\x1egit\x1enewline\x1echaracter
        set -gx tide_left_prompt_prefix:
        set -gx tide_left_prompt_separator_diff_color:\x20
        set -gx tide_left_prompt_separator_same_color:\x20
        set -gx tide_left_prompt_suffix:\x20
        set -gx tide_nix_shell_bg_color:normal
        set -gx tide_nix_shell_color:7EBAE4
        set -gx tide_nix_shell_icon:\uf313
        set -gx tide_node_bg_color:normal
        set -gx tide_node_color:44883E
        set -gx tide_node_icon:\u2b22
        set -gx tide_os_bg_color:normal
        set -gx tide_os_color:normal
        set -gx tide_os_icon:\uf31b
        set -gx tide_php_bg_color:normal
        set -gx tide_php_color:617CBE
        set -gx tide_php_icon:\ue608
        set -gx tide_private_mode_bg_color:normal
        set -gx tide_private_mode_color:FFFFFF
        set -gx tide_private_mode_icon:\ufaf8
        set -gx tide_prompt_add_newline_before:true
        set -gx tide_prompt_color_frame_and_connection:6C6C6C
        set -gx tide_prompt_color_separator_same_color:949494
        set -gx tide_prompt_icon_connection:\u00b7
        set -gx tide_prompt_min_cols:34
        set -gx tide_prompt_pad_items:false
        set -gx tide_pwd_bg_color:normal
        set -gx tide_pwd_color_anchors:00AFFF
        set -gx tide_pwd_color_dirs:0087AF
        set -gx tide_pwd_color_truncated_dirs:8787AF
        set -gx tide_pwd_icon:\uf07c
        set -gx tide_pwd_icon_home:\uf015
        set -gx tide_pwd_icon_unwritable:\uf023
        set -gx tide_pwd_markers:\x2ebzr\x1e\x2ecitc\x1e\x2egit\x1e\x2ehg\x1e\x2enode\x2dversion\x1e\x2epython\x2dversion\x1e\x2eruby\x2dversion\x1e\x2eshorten_folder_marker\x1e\x2esvn\x1e\x2eterraform\x1eCargo\x2etoml\x1ecomposer\x2ejson\x1eCVS\x1ego\x2emod\x1epackage\x2ejson
        set -gx tide_right_prompt_frame_enabled:false
        set -gx tide_right_prompt_items:status\x1ecmd_duration\x1econtext\x1ejobs\x1enode\x1evirtual_env\x1erustc\x1ejava\x1ephp\x1echruby\x1ego\x1ekubectl\x1etoolbox\x1eterraform\x1eaws\x1enix_shell\x1ecrystal
        set -gx tide_right_prompt_prefix:\x20
        set -gx tide_right_prompt_separator_diff_color:\x20
        set -gx tide_right_prompt_separator_same_color:\x20
        set -gx tide_right_prompt_suffix:
        set -gx tide_rustc_bg_color:normal
        set -gx tide_rustc_color:F74C00
        set -gx tide_rustc_icon:\ue7a8
        set -gx tide_shlvl_bg_color:normal
        set -gx tide_shlvl_color:d78700
        set -gx tide_shlvl_icon:\uf120
        set -gx tide_shlvl_threshold:1
        set -gx tide_status_bg_color:normal
        set -gx tide_status_bg_color_failure:normal
        set -gx tide_status_color:5FAF00
        set -gx tide_status_color_failure:D70000
        set -gx tide_status_icon:\u2714
        set -gx tide_status_icon_failure:\u2718
        set -gx tide_terraform_bg_color:normal
        set -gx tide_terraform_color:844FBA
        set -gx tide_terraform_icon:\x1d
        set -gx tide_time_bg_color:normal
        set -gx tide_time_color:5F8787
        set -gx tide_time_format:
        set -gx tide_toolbox_bg_color:normal
        set -gx tide_toolbox_color:613583
        set -gx tide_toolbox_icon:\u2b22
        set -gx tide_vi_mode_bg_color_default:normal
        set -gx tide_vi_mode_bg_color_insert:normal
        set -gx tide_vi_mode_bg_color_replace:normal
        set -gx tide_vi_mode_bg_color_visual:normal
        set -gx tide_vi_mode_color_default:949494
        set -gx tide_vi_mode_color_insert:87AFAF
        set -gx tide_vi_mode_color_replace:87AF87
        set -gx tide_vi_mode_color_visual:FF8700
        set -gx tide_vi_mode_icon_default:D
        set -gx tide_vi_mode_icon_insert:I
        set -gx tide_vi_mode_icon_replace:R
        set -gx tide_vi_mode_icon_visual:V
        set -gx tide_virtual_env_bg_color:normal
        set -gx tide_virtual_env_color:00AFAF
        set -gx tide_virtual_env_icon:\ue73c
      '';
      # issue from https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit = ''        fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /opt/homebrew/bin
                                 #>>> conda initialize >>>
                                 # !! Contents within this block are managed by 'conda init' !!
                                 eval /opt/homebrew/bin/conda "shell.fish" "hook" $argv | source
                                 # <<< conda initialize <<<
      '';
      plugins = with pkgs.fishPlugins; [
        # {
        #   name = "z";
        #   src = z;
        # }
        # {
        #   name = "fzf-fish";
        #   src = fzf-fish;
        # }
        # {
        #   name = "colored-man-pages";
        #   src = colored-man-pages;
        # }
        # {
        #   name = "autopair";
        #   src = autopair-fish;
        # }
        {
          name = "tide";
          src = tide.src;
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
  ];
}
