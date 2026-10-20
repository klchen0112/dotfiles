{ den, inputs, ... }:
{
  den.aspects.dsh = {
    dsh =
      {
        pkgs,
        lib,
        config,
        inputs,
        ...
      }:
      {
        #imports = with inputs; [
        #  dsh-nix.homeManagerModules.dsh
        #];
        #nixpkgs.overlays = with inputs; [
        #  dsh-nix.overlays.default
        #];
        #programs.dsh = {
        #  enable = true;
        #  profiles.headless = {
        #    plugins = [ "@deepseek-ai/dsh-base" "@deepseek-ai/dsh-headless" ];
        #  };
        #  profiles.web = {
        #    plugins = [ "@deepseek-ai/dsh-base" "@deepseek-ai/dsh-web-app" ];
        #  };
        #};
        home.packages = with pkgs; [
          llm-agents.dsh

          # `dsh plugin --profile <name> <pnpm args>` 会把参数转发给 PATH 上的 pnpm，
          # 找不到时会报 “dsh: pnpm was not found; install pnpm and make it available on PATH.”
          # 插件是装进 profile 的 node_modules 并在 node 下运行的，所以顺带保证 nodejs。
          pnpm
          nodejs
        ];
      };
  };
}
