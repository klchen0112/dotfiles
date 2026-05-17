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
    wondelai-skills = {
      url = "github:wondelai/skills";
      flake = false;
    };
  };
  den.aspects.hermes = {
    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.services.hermes-agent;

        # Derivation: wondelai/skills → ~/.hermes/skills/wondelai/<name>/SKILL.md
        wondelaiSkills = pkgs.runCommand "hermes-wondelai-skills" { } ''
          mkdir -p $out/wondelai
          for skill_src in ${inputs.wondelai-skills}/*/SKILL.md; do
            skill_dir=$(dirname "$skill_src")
            skill_name=$(basename "$skill_dir")
            mkdir -p "$out/wondelai/$skill_name"
            cp -r "$skill_dir"/* "$out/wondelai/$skill_name/"
          done
        '';
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
          extraPythonPackages = [
            pkgs.local.graphify
          ]
          ++ (with pkgs.python312Packages; [
            # httpx
            #aiohttp
            #cryptography
          ]); # its Python dep
          #extraPackages = [ pkgs.redis ];            # system binary it needs
          extraDependencyGroups = [
            "voice"
            "cli"
            "messaging"
            "mcp"
            "matrix"
            "termux-all"
          ];
          settings = {
            model = {
              "default" = "deepseek/deepseek-v4-pro";
              #"default" = "Qwen3.6-35B-A3B";
              provider = "deepseek";
              base_url = "https://api.deepseek.com";
              #"base_url" = "http://localhost:8080/v1";
            };
            providers = {
              custom = {
                "base_url" = "http://localhost:8080/v1";
                models = {
                  "mudler/Qwen3.6-35B-A3B-Claude-4.7-Opus-Reasoning-Distilled-APEX-MTP-GGUF" = {
                    stale_timeout_seconds = 1800;
                  };
                };
              };
              deepseek = {
                base_url = "https://api.deepseek.com";
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
          addToSystemPackages = true;
        };
        networking.firewall.allowedTCPPorts = [
          9119
        ];
        networking.firewall.allowedUDPPorts = [
          9119
        ];

        # Symlink wondelai/skills into hermes stateDir on every rebuild
        system.activationScripts."hermes-wondelai-skills" = lib.stringAfter [ "hermes-agent-setup" ] ''
          SKILLS_DIR="${cfg.stateDir}/.hermes/skills/wondelai"
          mkdir -p "$SKILLS_DIR"
          # Remove all old managed symlinks (skills removed upstream get cleaned)
          find "$SKILLS_DIR" -maxdepth 1 -type l -delete 2>/dev/null || true
          # Create fresh symlinks for all current skills
          for skill_dir in ${wondelaiSkills}/wondelai/*; do
            skill_name=$(basename "$skill_dir")
            ln -sfn "$skill_dir" "$SKILLS_DIR/$skill_name"
          done
          chown -R ${cfg.user}:${cfg.group} "$SKILLS_DIR"
        '';

        # Hermes dashboard systemd service (system-level)
        systemd.services.hermes-dashboard = {
          enable = true;
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
