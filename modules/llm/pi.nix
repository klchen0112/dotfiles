{ den, inputs, ... }:
{
  flake-file.inputs = {
    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.pi = {
    pi =
      {
        pkgs,
        lib,
        config,
        inputs,
        ...
      }:
      let
        piPython = pkgs.python3.withPackages (ps: [
          ps.matplotlib
          ps.pexpect
          ps.plumbum
          ps.polars
          ps.pyelftools
          ps.requests
        ]);
      in
      {
        imports = with inputs; [
          pi.homeModules.default
        ];
        # interpreter + tool prompt for the pi-agent-extensions python tool
        xdg.configFile."pi-agent-extensions/python/config.json" = {
          # replaces the hand-written file from before this was managed here
          force = true;
          text = builtins.toJSON {
            python = "${piPython}/bin/python3";
            prompt = "Available besides stdlib: polars, matplotlib, requests, plumbum, pexpect, pyelftools. Drive interactive programs (ssh, REPLs, debuggers) with pexpect: child = pexpect.spawn(cmd, encoding='utf-8') persists across calls, always pass timeout= to expect().";
          };
        };
        programs.pi.coding-agent = {
          enable = true;
          models = ./models.json;
          settings = {
            model = "Ornith-1.5-35B-A3B-Heretic-MTP-APEX";

          };
          # rules = ''Be concise.'';
          # skills = [ ./skills/my-skill ];
          # models = ./models.json;
          # settings.model = "gpt-5";
          # environment.PI_CODING_AGENT_DIR.value = "${config.home.homeDirectory}/.pi/agent";
          # environment.OPENAI_API_KEY.file = config.sops.secrets.openai-api-key.path;
        };

      };
  };
}
