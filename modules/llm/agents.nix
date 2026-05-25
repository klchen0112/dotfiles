{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      # url = "github:NousResearch/hermes-agent/v2026.4.30";
      url = "github:klchen0112/hermes-agent/feat/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.hermes = {
    hermes =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.programs.hermes-agent;
      in
      {
        imports = with inputs; [
          hermes-agent.homeManagerModules.default
        ];
        nixpkgs.overlays = with inputs; [
          hermes-agent.overlays.default
          llm-agents.overlays.default
        ];
        programs.hermes-agent = {
          enable = true;
          #         extraPlugins = [ my-plugin-src ];          # plugin source
          #extraPythonPackages = [
          #  pkgs.local.graphify
          #]
          #++ (with pkgs.python312Packages; [
          # httpx
          #aiohttp
          #cryptography
          #]); # its Python dep
          #extraPackages = [ pkgs.redis ];            # system binary it needs
          # extraDependencyGroups = [
          #   "voice"
          #   "cli"
          #   "messaging"
          #   "mcp"
          #   "matrix"
          #   "termux-all"
          # ];
          settings = {
            model = {
              #"default" = "deepseek/deepseek-v4-pro";
              "default" = "Qwopus3.6-35B-A3B-v1-APEX-MTP-I-Compact";
              # provider = "deepseek";
              provider = "custom";
              #base_url = "https://api.deepseek.com";
              "base_url" = "http://localhost:8080/v1";
            };
            providers = {
              deepseek = {
                base_url = "https://api.deepseek.com";
              };
              custom = {
                base_url = "http://localhost:8080/v1";

              };
            };
            toolsets = [ "all" ];
            max_turns = 100;
            terminal = {
              backend = "local";
              cwd = ".";
              timeout = 180;
            };
            compression = {
              enabled = true;
              threshold = 0.85;
              summary_model = "deepseek/deepseek-v4-pro";
            };
            memory = {
              memory_enabled = true;
              user_profile_enabled = true;
            };
            display = {
              compact = false;
              personality = "kawaii";
              show_reasoning = true;
            };
            agent = {
              max_turns = 60;
              verbose = false;
            };
          };
          environmentFiles = [ config.sops.secrets."hermes-env".path ];
        };

        # Hermes dashboard systemd user service
        systemd.user.services.hermes-dashboard = {
          Unit = {
            Description = "Hermes Agent Web Dashboard";
            After = [ "network.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 10;
            ExecStart = "${pkgs.hermes-agent}/bin/hermes dashboard --no-open --host 0.0.0.0 --insecure";
            StandardOutput = "journal";
            StandardError = "journal";
          };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };
  den.aspects.llm-agents = {
    llm-agents =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          inputs.llm-agents.overlays.default
          inputs.hermes-agent.overlays.default
        ];

        nix.settings = {
          extra-substituters = [
            "https://cache.numtide.com"
          ];
          extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "cache.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
        home.packages = with pkgs; [
          hermes-agent
          # llm-agents.opencode
          # opencode
        ];
      };
  };
}
