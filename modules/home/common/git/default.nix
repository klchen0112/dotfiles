# fish configuration
#
{ lib
, pkgs
, ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      ".devenv"
    ];
    attributes = [ "*.pdf diff=pdf" ];
    lfs.enable = true;
    userName = "klchen0112";
    userEmail = "klchen0112@gmail.com";
    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
    delta = {
      enable = true;
      options = {
        features = lib.mkDefault "side-by-side";
      };
    };
    extraConfig = {
      init.defaultBranch = "master"; # https://srid.ca/unwoke

      core.editor = "emacsclient";
      core.quotepath = false;
      core.autocrlf = false;
      # For supercede
      core.symlinks = true;
      #protocol.keybase.allow = "always";
      credential.helper = "store --file ~/.config/git/git-credentials";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
