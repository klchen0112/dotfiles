{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      # url = "github:NousResearch/hermes-agent/v2026.4.30";
      # url = "git+file:///home/klchen/my/hermes-agent";
      url = "github:klchen0112/hermes-agent/own";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.hermes = {
    hermes =
      {
        pkgs,
        lib,
        config,
        inputs,
        ...
      }:
      let
        cfg = config.programs.hermes-agent;

        # Build Understand-Anything plugin from source via Nix.
        # Produces the built plugin with pnpm deps and compiled TypeScript.
        understand-anything-plugin = pkgs.stdenv.mkDerivation {
          pname = "understand-anything-plugin";
          version = "unstable";
          src = inputs.understand-anything;

          nativeBuildInputs = [
            pkgs.nodejs_22
            pkgs.pnpm_9
            pkgs.pnpmConfigHook
          ];

          pnpmDeps = pkgs.fetchPnpmDeps {
            pname = "understand-anything-plugin";
            src = inputs.understand-anything;
            pnpm = pkgs.pnpm_9;
            pnpmWorkspaces = [ "@understand-anything/core" ];
            fetcherVersion = 3;
            # Placeholder — replace with real hash after first build attempt
            hash = "sha256-gZhRLMOzq9kxD0dnRM4KYjWmW18hOpvVIW6gXUZ26Qo=";
          };

          pnpmWorkspaces = [ "@understand-anything/core" ];

          buildPhase = ''
            runHook preBuild
            pnpm install --frozen-lockfile --offline --filter @understand-anything/core
            pnpm --filter @understand-anything/core build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r . $out/
            runHook postInstall
          '';
        };
      in
      {
        imports = with inputs; [
          hermes-agent.homeManagerModules.default
        ];
        nixpkgs.overlays = with inputs; [
          hermes-agent.overlays.default
          llm-agents.overlays.default
        ];
        home.packages = with pkgs; [
          # local.graphify
        ];
        programs.hermes-agent = {
          enable = true;
          #         extraPlugins = [ my-plugin-src ];          # plugin source
          extraPythonPackages = [
            # pkgs.local.graphify
          ]
          ++ (with pkgs.python312Packages; [
            # graphifyy
            # playwright
            # playwright
            # httpx
            #aiohttp
            #cryptography
            #python-telegram-bot
          ]); # its Python dep
          extraPlugins = with pkgs; [
            (pkgs.fetchFromGitHub {
              owner = "stephenschoettler";
              repo = "hermes-lcm";
              name = "hermes-lcm";
              rev = "v0.12.0";
              hash = "sha256-RyzKjtNChDtuWi51JTAL0og0X+NzD7mHLUHhqTdko2g=";
            })
          ];
          extraPackages = with pkgs; [
            agent-browser
            playwright
            nodejs_22
          ]; # system binary it needs
          extraDependencyGroups = [
            "acp"
            #"voice"
            "cli"
            "messaging"
            "mcp"
            #"matrix"
            #"termux-all"
          ];
          settings = {
            plugins = {
              enabled = [
                "hermes-lcm"
                "model-providers/deepseek"
                "model-providers/custom"
              ];
            };
            context = {
              engine = "lcm";
            };
            model = {
              default = "Carnice-Qwen3.6-MoE-35B-A3B-APEX-MTP-I-Compact";
              provider = "i12400";
              base_url = "http://i12400.klchen.duckdns.org:8080/v1";
              #provider = "custom";
              # base_url = "https://api.deepseek.com";
              #"base_url" = "http://localhost:8080/v1";
            };

            custom_providers = [
              {
                name = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
                models = [
                  "Carnice-Qwen3.6-MoE-35B-A3B-APEX-MTP-I-Compact"
                  "unsloth/gemma-4-26B-A4B-it-qat-GGUF"
                  "Qwopus3.6-35B-A3B-v1-APEX-MTP-I-Compact"
                ];
              }
            ];

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
            auxiliary = {
              vision = {
                provider = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
                model = "Carnice-Qwen3.6-MoE-35B-A3B-APEX-MTP-I-Compact";
              };
              web_extract = {
                provider = "i12400";
                model = "Carnice-Qwen3.6-MoE-35B-A3B-APEX-MTP-I-Compact";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
              };
              curator = {
                model = "Carnice-Qwen3.6-MoE-35B-A3B-APEX-MTP-I-Compact";
                provider = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
              };
            };
            skills = {
              external_dirs = [
                "~/.agents/skills"
              ];

            };
            checkpoints = {
              enabled = true;
            };
            lsp = {
              enabled = true;
              # 每次写入后等待诊断结果的方式。
              wait_mode = "document"; # "document" 或 "full"
              wait_timeout = 5.0;

              # 处理缺失服务器二进制文件的策略。
              #   auto    — 通过 npm/pip/go install 安装到 <HERMES_HOME>/lsp/bin
              #   manual  — 仅使用已在 PATH 上的二进制文件
              install_strategy = "manual";
            };
            curator = {
              enabled = true;
              interval_hours = 168; # 7 days
              min_idle_hours = 2;
              stale_after_days = 30;
              archive_after_days = 90;
            };
          };
        };

        # Hermes dashboard systemd user service (Linux)
        systemd.user.services.hermes-dashboard = {
          Unit = {
            Description = "Hermes Agent Web Dashboard";
            After = [ "network.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 10;
            Environment = [
              "HERMES_HOME=${cfg.stateDir}/.hermes"
            ];
            ExecStart = "${pkgs.hermes-agent}/bin/hermes dashboard --no-open --host 0.0.0.0 --insecure";
            StandardOutput = "journal";
            StandardError = "journal";
          };

          Install.WantedBy = [ "default.target" ];
        };

        # Symlink ~/.understand-anything-plugin → Nix-built plugin so the
        # skills' runtime scripts can resolve @understand-anything/core.
        home.file.".understand-anything-plugin".source =
          "${understand-anything-plugin}/understand-anything-plugin";

        # Hermes dashboard launchd user agent (macOS / Darwin)
        launchd.agents.hermes-dashboard = {
          enable = true;
          config = {
            Label = "org.nix-community.home.hermes-dashboard";
            ProgramArguments = [
              "${pkgs.hermes-agent}/bin/hermes"
              "dashboard"
              "--no-open"
              "--host"
              "0.0.0.0"
              "--insecure"
            ];
            RunAtLoad = true;
            KeepAlive = {
              SuccessfulExit = false;
              Crashed = true;
            };
            EnvironmentVariables = {
              HERMES_HOME = "${cfg.stateDir}/.hermes";
            };
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/hermes-dashboard.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/hermes-dashboard.err.log";
            ProcessType = "Background";
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
          # hermes-agent is provided by programs.hermes-agent (home-manager module) above
          # llm-agents.opencode
          # opencode
        ];
      };
  };
}
