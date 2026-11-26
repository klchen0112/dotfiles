{
  den,
  ...
}:
{
  # OpenAI Codex CLI（https://github.com/openai/codex），由 llm-agents.nix 打包。
  #
  # 走 llm-agents 的 overlay（den.aspects.llm-agents → shared-nixpkgs），
  # 所以用 pkgs.llm-agents.codex。对应用户的 roles 中需要有 "llm-agents"，
  # host roles 会由 modules/den.nix 自动补全。
  #
  # 凭证与配置交给 codex 自己管理（$CODEX_HOME，默认 ~/.codex 下）。
  # 记忆服务的 stdio 桥由 Emacs 的 mcp-server-lib 提供，不单独打包。
  den.aspects.codex.homeManager =
    {
      lib,
      pkgs,
      ...
    }:
    let
      orgWikiMcp = import ../../lib/org-wiki-mcp.nix { inherit pkgs; };
    in
    {
      home.activation.codexOrgWikiMemory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # 旧条目是 stdio 命令，换成 URL 前先删掉（首次不存在也不报错）。
        run ${pkgs.llm-agents.codex}/bin/codex mcp remove org_wiki_memory || true
        run ${pkgs.llm-agents.codex}/bin/codex mcp add org_wiki_memory --url ${orgWikiMcp.url}
      '';
      home.packages = [
        pkgs.llm-agents.codex
      ];
    };
}
