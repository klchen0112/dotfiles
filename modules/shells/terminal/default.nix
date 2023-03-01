{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    exa
    bat
    tree
    starship
  ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      shlvl = {
        disabled = false;
        symbol = "ﰬ";
        style = "bright-red bold";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };
      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
      hostname = {
        style = "bright-green bold";
        ssh_only = true;
      };
      cmd_duration = {
        disabled = false;
        symbol = "⏱ $duration";
      };
      git_branch = {
        disabled = false;
        format = "[$symbol$branch]($style) ";
        symbol = "שׂ";
        style = "bright-yellow bold";
      };
      git_commit = {
        only_detached = true;
        format = "[ﰖ$hash]($style) ";
        style = "bright-yellow bold";
      };
      git_state = {
        style = "bright-purple bold";
      };
      git_status = {
        disabled = false;
      };
      sudo = {
        disabled = false;
        symbol = "as $symbol";
      };
      python = {
        disabled = false;
        format = "${symbol}${pyenv_prefix}(${version})(\($virtualenv\))";
      };
    };
    nix_shell = {
      disabled = false;
      foramt = "[$symbol$name]($style)";
      symbol = "";
    };
    nodejs = {
      disabled = false;
      symbol = "$symbol($version)";
    };
    cmake = {
      disabled = false;
      symbol = "$symbol($version)";
    };
  };
}
