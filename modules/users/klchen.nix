{
  den,
  inputs,
  lib,
  # deadnix: skip # enable <den/brackets> syntax for demo.
  __findFile,
  ...
}:
let
  # codex CLI / ChatGPT 桌面应用目前只装在 a99r50 / mbp-m1 上
  agentHosts = [
    "a99r50"
    "mbp-m1"
  ];
  # obsidian 只在 a99r50 / mbp-m1 上装
  obsidianHosts = [
    "a99r50"
    "mbp-m1"
  ];
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8gTw2jmEZ5Qs/KprEb5lWzYjflOQlmA6vjXqnq8Bu klchen@i12400"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxpox++VSFrTqPj8+Ixt99DdCeS5jDVpeX5rZ9fz5Il klchen@a99r50"
  ];
in
{
  den.aspects.klchen = {
    # 只有「这台机器上有 klchen」时才需要这些 host 级配置：
    # 用 `provides.to-hosts` 点名投递（den 0.19 是核心能力；0.20 起由
    # `den.batteries.mutual-provider` 负责接收，本仓库在 `den.default.includes`
    # 里已经 include 了 `<den/mutual-provider>`）。
    # 这样不会假定「所有 host 都有 klchen」。
    provides.to-hosts.nixos = {
      services.openssh.settings.AllowUsers = [
        "klchen"
        "remotebuild"
      ];
      # klchen 的公钥同时也是各 host root 的登录密钥（deploy-rs / 远程构建都用它）。
      users.users.root.openssh.authorizedKeys.keys = keys;
      nix.settings.trusted-users = [ "klchen" ];
      programs.bash.enable = true;
      # `home-manager.*` 是“有 HM 用户才存在”的 option：跟着这个投递走，
      # 没有 HM 用户的 host 就不会碰到它。
      home-manager.backupFileExtension = "hmbp";

      # 账号字段留在 nixos 类而不是 den 的 `user` 类：`user` 类同样会路由进
      # nix-darwin 的 users.users.<name>，那里没有 isNormalUser / extraGroups。
      users.users.klchen = {
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$WX1yl8edHz32y77s640GV.$M1U0keGszxKa9efTMnTG/VJAIOqtDj0mPEToL6cBF13";
        extraGroups = [
          "audio"
          "input"
          "networkmanager"
          "sound"
          "tty"
          "wheel"
          "hermes"
          "docker"
        ];
      };
    };

    user = {
      createHome = true;
      openssh.authorizedKeys.keys = keys;
    };
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {
        nixpkgs.overlays = [
          inputs.self.overlays.default
        ];
        nixpkgs.config.allowUnfree = true;
        nix.settings.trusted-users = [ "klchen" ];
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night-eighties.yaml";
        home.username = lib.mkDefault " klchen";
        home.homeDirectory = lib.mkForce (
          if pkgs.stdenvNoCC.hostPlatform.isDarwin then "/Users/klchen" else "/home/klchen"
        );

        # npm global prefix (see ~/.npmrc: prefix=/home/klchen/.npm-global)
        home.sessionPath = [ "$HOME/.npm-global/bin" ];
        programs.git.settings.user = {
          name = "klchen0112";
          email = "klchen0112@gmail.com";
        };
        sops.secrets.hermes-env = {
          sopsFile = ../../secrets/klchen/hermes.yaml;
          format = "yaml";
        };
      };
    provides.a99r50 = {
      homeManager = { config, ... }: {
        sops.secrets.hermes-telegram-env = {
          sopsFile = ../../secrets/klchen/hermes-telegram.env;
          format = "dotenv";
        };
        sops.secrets.hermes-discord-env = {
          sopsFile = ../../secrets/klchen/hermes-discord.env;
          format = "dotenv";
        };

        programs.hermes-agent = {
          desktop.enable = true;
        };
        services.hermes-agent = {
          enable = true;
          backend = {
            mode = "dashboard";
          };
          environmentFiles = [
            config.sops.secrets."hermes-telegram-env".path
            config.sops.secrets."hermes-discord-env".path
            config.sops.secrets."hermes-env".path
          ];
          settings.platforms = {
            telegram = {
              enabled = true;
            };
            discord = {
              enabled = true;
            };
          };
        };
      };
    };

    includes = [

      <den/define-user>
      <den/primary-user>
      #      (den.provides.user-shell "nu")
    ]
    ++ [
      # <hmPlatforms>
      <stylix-home>
      <python>
      <java>
      <nushell>
      <bash>
      <zsh>
      <starship>
      <utils>
      <git>
      <kitty>
      <ssh>
      <nix-index>
      <nix-home>
      <emacs-twist>
      <vscode>
      <noctalia-shell>
      <niri-home>
      <ghostty>
      <zen>
      <paneru>
      <llm-deploy-cuda>
      <llm-deploy-rocm>
      <llm-deploy-vulkan>
      <llm-agents>
      <skill>
      <inputmethod>
      <k8s>
      <syncthing>
      <font-home>
      <aria2>
      <im>
      <sops-home>
      <skill>
      <hermes>
      <pi>
      <media>
      <chrome>
      <dsh>
      <codex>
      <chatgpt>
      <obsidian>
    ];
  };
}
