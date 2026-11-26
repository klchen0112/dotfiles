{
  den,
  ...
}:
{
  # 把 Emacs 里的 org-wiki MCP 服务暴露成常驻的 streamable HTTP 端点，
  # agent 只连 http://127.0.0.1:8808/mcp，不再各自启动 stdio 桥进程。
  den.aspects.org-wiki-mcp.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mcp = import ../../lib/org-wiki-mcp.nix { inherit pkgs; };
      proxy = "${pkgs.mcp-proxy}/bin/mcp-proxy";
      args = [
        "--port"
        (toString mcp.port)
        # 桥脚本从环境里找 emacsclient/bash/coreutils，代理需要原样传下去。
        "--pass-environment"
        "--"
        mcp.stdioScript
        "--server-id=org-wiki-memory"
      ];
      path = lib.makeBinPath [
        pkgs.bash
        pkgs.coreutils
        config.services.emacs.package
      ];
    in
    lib.mkMerge [
      {
        # 桥脚本是 mcp-server-lib 的一部分，保证它在 gc 后仍在闭包内。
        home.packages = [ pkgs.emacsPackages.mcp-server-lib ];
      }
      (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
        systemd.user.services.org-wiki-mcp = {
          Unit.Description = "MCP streamable HTTP bridge to Emacs org-wiki";
          Service = {
            ExecStart = "${proxy} ${lib.escapeShellArgs args}";
            Environment = [ "PATH=${path}" ];
            Restart = "always";
            RestartSec = 2;
          };
          Install.WantedBy = [ "default.target" ];
        };
      })
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        launchd.agents.org-wiki-mcp = {
          enable = true;
          config = {
            ProgramArguments = [ proxy ] ++ args;
            EnvironmentVariables.PATH = path;
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/org-wiki-mcp.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/org-wiki-mcp.log";
          };
        };
      })
    ];
}
