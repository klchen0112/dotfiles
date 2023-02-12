#
# Git
#
{ config, lib, pkgs, ... }:

{

  programs = {

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      extraConfig = {
        init.defaultBranch = "master"; # https://srid.ca/unwoke
        core.editor = "emacsclient";
        #protocol.keybase.allow = "always";
        credential.helper = "store --file ~/.git-credentials";
        pull.rebase = "false";
        # For supercede
        core.symlinks = true;
      };
    };

  };
}
