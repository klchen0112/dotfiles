{ den, inputs, ... }:
let
  # 社区维护的 dsh Nix 打包：https://github.com/Moraxyc/deepseek-harness.nix
  # 直接消费 flake 自身的 packages / legacyPackages（而不是 overlay 进本地 nixpkgs），
  # 这样 dsh / dsh-desktop 及其 bundle 都能命中 deepseek-harness-nix.cachix.org 的缓存。
  harness = inputs.deepseek-harness;
in
{
  flake-file.inputs = {
    deepseek-harness = {
      url = "github:Moraxyc/deepseek-harness.nix";
      # 故意不让 nixpkgs follows：cachix 里的 dsh / dsh-desktop 是按它自己 pin 的
      # nixpkgs 构建的，follows 反而会掉缓存。
    };
  };

  den.aspects.dsh = {
    dsh =
      { pkgs, ... }:
      let
        system = pkgs.stdenv.hostPlatform.system;
        dshPkgs = harness.packages.${system};
        dshBundles = harness.legacyPackages.${system}.bundles;

        # flake 的 HM runtime override 会清空 profiles 再交给 dshBundleCheckHook，
        # 于是 hook 在 $TMPDIR 里 seed 出 nix-tui 后只能无 PTY 地探测它，
        # dsh-tui（Ink）会报 "Raw mode is not supported" 让 runtime 包构建失败。
        # 这里在 package 层关掉该构建期检查；TUI 用真 PTY（script -qec）单独验证。
        dshPackage = dshPkgs.dsh // {
          override =
            args:
            (dshPkgs.dsh.override args).overrideAttrs (_: {
              dontDshBundleCheck = "1";
            });
        };
      in
      {
        imports = [ harness.homeModules.default ];

        # 输入的 flake nixConfig 不会被继承，这里显式声明 harnes 的二进制缓存
        nix.settings = {
          extra-substituters = [ "https://deepseek-harness-nix.cachix.org" ];
          extra-trusted-public-keys = [
            "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
          ];
        };

        programs.dsh = {
          enable = true;
          # 显式使用 flake 构建产物（模块顶层会无条件求值 cfg.package，故不用 overlay）
          package = dshPackage;

          # tui / web 两个变体，材料化后分别是 nix-tui / nix-web
          profiles =
            let
              common = with dshBundles; [
                agent-teams
                subagent-codex
                better-sidebar
                billion-context

              ];
            in

            {
              tui = {
                bundles =
                  with dshBundles;
                  [
                    tui

                  ]
                  ++ common;
                mode = "managed";
              };
              web = {
                bundles =
                  with dshBundles;
                  [
                    web-app
                  ]
                  ++ common;
                mode = "managed";
              };
            };

          # 不带 --profile 时默认进 TUI（必须用材料化名）
          defaultProfile = "nix-tui";
        };

        # 用户级 web 服务 dsh-web.service（默认 127.0.0.1:3080），与 CLI 共用 ~/.dsh
        services.dsh = {
          enable = true;
          profile = "nix-web";
          port = 3080;
        };

        # `dsh plugin --profile <name> <pnpm args>` 会把参数转发给 PATH 上的 pnpm，
        # 找不到时会报 “dsh: pnpm was not found; install pnpm and make it available on PATH.”
        # 插件是装进 profile 的 node_modules 并在 node 下运行的，所以顺带保证 nodejs。
        home.packages = with pkgs; [
          pnpm
          nodejs
        ];
      };
  };
}
