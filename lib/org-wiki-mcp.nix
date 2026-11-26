# org-wiki 的 MCP 服务跑在 Emacs 里（org-wiki-mcp.el），mcp-server-lib 只提供
# stdio 桥，没有自己的网络监听。为了不让每个 agent 各自 spawn 一个桥进程，
# 这里由常驻的 mcp-proxy 把它暴露成 streamable HTTP，agent 只连 URL。
# pi 的客户端声明在 ~/pi-config 的 my.pi.mcp 里，改端口要两边一起改。
{ pkgs }:
let
  mcpServerLib = pkgs.emacsPackages.mcp-server-lib;
in
{
  port = 8808;
  url = "http://127.0.0.1:8808/mcp";
  stdioScript = "${mcpServerLib}/share/emacs/site-lisp/elpa/mcp-server-lib-${mcpServerLib.version}/emacs-mcp-stdio.sh";
}
