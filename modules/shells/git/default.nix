#
# Git
#
{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      ignores = ["*~" "*.swp"];
      attributes = ["*.pdf diff=pdf"];
      lfs.enable = true;
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
