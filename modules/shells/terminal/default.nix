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
      format = "$shlvl$shell$username$hostname$git_branch$git_commit$git_state$git_status$cmake$python$nix_shell$directory$cmd_duration$sudo$line_break$jobs$character";
      shlvl = {
        disabled = false;
        symbol = "ﰬ";
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
        format = "as $symbol";
      };
      python = {
        disabled = false;
        format = "[$symbol$pyenv_prefix]($version)(\($virtualenv\))";
        symbol = " ";
      };
      nix_shell = {
        disabled = false;
        format = "[$symbol$name]($style)";
        symbol = "";
      };
      nodejs = {
        disabled = false;
        format = "[$symbol]($version)";
        symbol = " ";
      };
      cmake = {
        disabled = false;
        format = "$symbol($version)";
      };
    };
  };
}
