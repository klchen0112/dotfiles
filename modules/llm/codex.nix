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
  # config.toml / auth.json，首次运行 `codex login` 生成），所以这里只装二进制，
  # 不用 home-manager 接管配置文件（只读软链会挡住登录/写入）。
  den.aspects.codex.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.llm-agents.codex
      ];
    };
}
