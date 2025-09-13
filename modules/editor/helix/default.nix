{
  flake.modules.homeManager.helix =
    {
      lib,
      pkgs,
      ...
    }:
    {
      stylix.targets.helix.enable = true;
      programs.helix = {
        enable = true;
        # settings from https://github.com/colemickens/nixcfg/blob/main/mixins/helix.nix
        settings = {
          editor = {
            auto-pairs = true;
            bufferline = "always";
            color-modes = true;
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            cursorcolumn = true;
            cursorline = true;
            gutters = [
              "diagnostics"
              "line-numbers"
              "spacer"
              "diff"
            ];
            file-picker = {
              hidden = false;
            };
            indent-guides = {
              render = true;
              character = "│";
            };
            line-number = "relative";
            lsp = {
              display-messages = true;
            };
            mouse = true;
            rulers = [
              80
              120
            ];
            statusline = {
              left = [
                "mode"
                "spinner"
                "version-control"
                "file-name"
                "file-modification-indicator"
                "read-only-indicator"
              ];
              center = [ ];
              right = [
                "register"
                "file-type"
                "diagnostics"
                "selections"
                "position"
                "position-percentage"
              ];
            };
            true-color = true;
            whitespace = {
              render.space = "all";
              render.tab = "all";
              render.newline = "all";
              characters.space = " ";
              characters.nbsp = "⍽";
              characters.tab = "→";
              characters.newline = "⏎";
              characters.tabpad = "-";
            };
          };
        };

        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          }
        ];
      };
    };
}
