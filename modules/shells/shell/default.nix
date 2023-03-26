{pkgs, ...}: {
  home.packages = with pkgs; [
    exa
    tree
  ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$shlvl$shell$username$hostname$git_branch$git_commit$git_state$git_status$cmake$python$nix_shell$directory$cmd_duration$sudo$line_break$jobs$character";
      shlvl = {
        disabled = false;
        style = "bright-red bold";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-black) ";
        zsh_indicator = "[ZSH](bright-black) ";
      };
      username = {
        disabled = false;
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
      hostname = {
        disabled = false;
        style = "bright-green bold";
        ssh_only = true;
      };
      cmd_duration = {
        disabled = false;
        format = "⏱ $duration";
      };
      git_branch = {
        disabled = false;
        format = "[$symbol $branch]($style) ";
        symbol = "שׂ";
        style = "bright-yellow bold";
      };
      git_commit = {
        disabled = false;
        only_detached = true;
        format = "[$hash]($style) ";
        style = "bright-yellow bold";
      };
      git_state = {
        disabled = false;
        style = "bright-purple bold";
      };
      git_status = {
        disabled = false;
      };
      sudo = {
        disabled = false;
        format = "as $symbol";
      };
      python = {
        disabled = false;
        format = "[$pyenv_prefix]($version)(\($virtualenv\))";
      };
      nix_shell = {
        disabled = false;
        format = "[$name]($style)";
      };
      nodejs = {
        disabled = false;
        format = "($version)";
      };
      cmake = {
        disabled = false;
        format = "($version)";
      };
    };
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfLight";
    };
  };
}
