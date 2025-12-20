topLevel: {
  flake.modules.homeManager.git =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        ignores = [
          "*~"
          "*.swp"
          ".DS_Store"
          ".devenv"
        ];
        attributes = [ "*.pdf diff=pdf" ];
        lfs.enable = true;

        settings = {

          user = {

            name = topLevel.config.flake.meta.users.${config.home.username}.username;
            email = topLevel.config.flake.meta.users.${config.home.username}.email;

          };
          alias = {
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
            core = {
              ignorecase = false;
              editor = "emacsclient";
              quotepath = false;
              autocrlf = false;
              symlinks = true;
            };
            # commit.gpgSign = true;
            # tag.gpgSign = true;
            # user.signingkey = "8041DF8D45CD149D";
            #protocol.keybase.allow = "always";
            pull.rebase = true;
            push.autoSetupRemote = true;
          };
        };
      };
        home.packages = with pkgs; [
          gh
        ];
    };
}
