{ den, inputs, ... }:
{
  flake-file.inputs = {
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      # url = "git+file:///home/klchen/my/hermes-agent";
      # url = "github:klchen0112/hermes-agent/own";

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
        cfg = config.services.hermes-agent;
      in
      {
        imports = with inputs; [
          hermes-agent.homeManagerModules.default
        ];
        nixpkgs.overlays = with inputs; [
          hermes-agent.overlays.default
        ];
        home.packages = with pkgs; [
          # local.graphify
        ];

        # upstream hermes-agent 把 environment/environmentFiles 写进
        # $HERMES_HOME/.env 的 home.activation 项叫 "hermesAgentSetup"，只排在
        # writeBoundary/linkGeneration 之后；而真正解密 sops secret 的
        # "sops-nix" 项按名字排在它后面。于是新声明的 secret 在第一次重建时
        # 还不存在，合并脚本只打印 WARNING 就静默跳过（telegram/discord 就这么
        # 丢过一次）。不能给已有条目追加 after，也不能去读同一 option 的兄弟项
        # （会无限递归），所以在 sops-nix 之后自己重写一遍 .env——每次都从零
        # 重写，所以幂等。
        home.activation.hermesEnvAfterSops =
          let
            envBase = pkgs.writeText "hermes-env-base" (
              lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}=${v}") cfg.environment)
              + lib.optionalString (cfg.environment != { }) "\n"
            );
          in
          lib.mkIf (cfg.enable && (cfg.environment != { } || cfg.environmentFiles != [ ])) (
            lib.hm.dag.entryAfter [ "sops-nix" ] ''
              dest=${lib.escapeShellArg "${cfg.hermesHome}/.env"}
              $DRY_RUN_CMD install -m 0600 ${envBase} "$dest"
              for f in ${lib.concatMapStringsSep " " lib.escapeShellArg cfg.environmentFiles}; do
                if [ -r "$f" ]; then
                  printf '\n' >> "$dest"
                  cat "$f" >> "$dest"
                else
                  echo "hermes-agent: WARNING cannot read environmentFile $f" >&2
                fi
              done
            ''
          );
        programs.hermes-agent = {
          enable = true;
        };

        services.hermes-agent = {
          enable = true;
          #         extraPlugins = [ my-plugin-src ];          # plugin source
          hermesHome = "${config.home.homeDirectory}/.local/share/hermes/.hermes";
          gateway.enable = true;
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
              rev = "v0.20.0";
              hash = "sha256-yJ1Nn+su7YbKd+cgVOizXChzLbKHqTprSprF1p9/HYk=";
            })
          ];
          extraPackages = with pkgs; [
            agent-browser
            playwright
            nodejs
          ]; # system binary it needs
          extraDependencyGroups = [
            # `hermes acp` / `hermes-acp` / `python -m acp_adapter`（ACP server）
            "acp"
            #"voice"
            "messaging"
            "mcp"
            #"matrix"
            "termux-all"
          ];
          settings = {
            model = {
              default = "Tiel-Coder-35B-A3B-APEX-MTP-I-Compact";
              provider = "i12400";
              base_url = "http://i12400.klchen.duckdns.org:8080/v1";
            };
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

            custom_providers = [
              {
                name = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
                models = [
                  "Qwen3.8-27B-GSQ-RCO-IQ3_S"
                  "Tiel-Coder-35B-A3B-APEX-MTP-I-Compact"
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
              summary_model = "deepseek/deepseek-v4-flash";
            };
            memory = {
              memory_enabled = true;
              user_profile_enabled = true;
            };
            display = {
              compact = false;
              interface = "tui";
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
                model = "Ornith-1.5-35B-A3B-Heretic-MTP-APEX";
              };
              web_extract = {
                model = "Ornith-1.5-35B-A3B-Heretic-MTP-APEX";
                provider = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
              };

              curator = {
                model = "Ornith-1.5-35B-A3B-Heretic-MTP-APEX";
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

              # 处理缺失二进制文件的策略。
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

      };
  };
}
