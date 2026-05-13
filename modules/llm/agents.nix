{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.hermes = {
    nixos =
      { pkgs, config, ... }:
      let
        cfg = config.services.hermes-agent;
      in
      {
        imports = with inputs; [
          hermes-agent.nixosModules.default
        ];
        nixpkgs.overlays = with inputs; [
          hermes-agent.overlays.default
          llm-agents.overlays.default
        ];
        # configuration.nix
        security.sudo.extraRules = [
          {
            users = [ "klchen" ];
            commands = [
              {
                command = "/run/current-system/sw/bin/docker";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
        services.hermes-agent = {
          enable = true;
          container = {
            enable = false;
            hostUsers = [ "klchen" ];
          };
          #         extraPlugins = [ my-plugin-src ];          # plugin source
          extraPythonPackages = [ pkgs.local.graphify ]; # its Python dep
          #extraPackages = [ pkgs.redis ];            # system binary it needs
          settings = {
            model = {
              "default" = "mudler/Carnice-Qwen3.6-MoE-35B-A3B-APEX";
              "provider" = "custom";
              "base_url" = "http://localhost:8080/v1";
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
            };
            agent = {
              max_turns = 60;
              verbose = false;
            };
          };
          environmentFiles = [ config.sops.secrets."hermes-env".path ];
          addToSystemPackages = true;
        };
        networking.firewall.allowedTCPPorts = [
          9119
        ];
        networking.firewall.allowedUDPPorts = [
          9119
        ];

        # Hermes dashboard systemd service (system-level)
        systemd.services.hermes-dashboard = {
          description = "Hermes Agent Web Dashboard";
          after = [
            "hermes-agent.service"
            "network-online.target"
          ];
          wants = [ "network-online.target" ];

          environment = {
            HOME = cfg.stateDir;
            HERMES_HOME = "${cfg.stateDir}/.hermes";
            HERMES_MANAGED = "true";
            MESSAGING_CWD = cfg.workingDirectory;
          };

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            Restart = "on-failure";
            RestartSec = 10;

            # --host 0.0.0.0: listen on all interfaces (LAN-accessible)
            # --insecure: needed to bind to non-localhost addresses
            # --no-open: no browser auto-open in headless service
            ExecStart = "${pkgs.hermes-agent}/bin/hermes dashboard --no-open --host 0.0.0.0 --insecure";

            StandardOutput = "journal";
            StandardError = "journal";
          };

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
