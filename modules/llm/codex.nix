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
  # 凭证与配置交给 codex 自己管理（$CODEX_HOME，默认 ~/.codex 下的
  # 用 Codex CLI 合并记忆服务条目，以便 config.toml 保持可写。
  den.aspects.codex.homeManager =
    { lib, pkgs, ... }:
    {
      home.activation.codexOrgWikiMemory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.llm-agents.codex}/bin/codex mcp add org_wiki_memory -- \
          ${pkgs.local.org-wiki-memory}/bin/org-wiki-memory
      '';
      home.packages = [
        pkgs.llm-agents.codex
      ];
    };
}
