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
            # (pkgs.fetchFromGitHub {
            #   owner = "stephenschoettler";
            #   repo = "hermes-lcm";
            #   name = "hermes-lcm";
            #   rev = "v0.20.0";
            #   hash = "sha256-RyzKjtNChDtuWi51JTAL0og0X+NzD7mHLUHhqTdko2g=";
            # })
          ];
          extraPackages = with pkgs; [
            agent-browser
            playwright
            nodejs_22
          ]; # system binary it needs
          extraDependencyGroups = [
            "acp"
            #"voice"
            "messaging"
            "mcp"
            #"matrix"
            "termux-all"
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

            custom_providers = [
              {
                name = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
                models = [
                  "Ornith-1.5-35B-A3B-ROCmFP4"
                ];
              }
              {
                name = "a99r50";
                base_url = "http://a99r50.klchen.duckdns.org:8080/v1";
                models = [
                  "Ornith-1.0-9B-NVFP4-MTP-GGUF"
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
                model = "Ornith-1.5-35B-A3B-ROCmFP4";
              };
              web_extract = {
                model = "Ornith-1.5-35B-A3B-ROCmFP4";
                provider = "i12400";
                base_url = "http://i12400.klchen.duckdns.org:8080/v1";
              };

              curator = {
                model = "Ornith-1.5-35B-A3B-ROCmFP4";
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
