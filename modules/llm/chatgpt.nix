{
  den,
  ...
}:
{
  # OpenAI 官方 ChatGPT / Codex 桌面应用（https://developers.openai.com/codex/app）。
  #
  # Linux 通过 llm-agents 安装，mbp-m1 通过主机配置中的 Homebrew cask 安装。
  den.aspects.chatgpt.chatgpt =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      orgWikiMcp = import ../../lib/org-wiki-mcp.nix { inherit pkgs; };
      json = name: value: pkgs.writeText name (builtins.toJSON value);
      catalog = json "marketplace.json" {
        name = "org-wiki-local";
        interface.displayName = "Org Wiki";
        plugins = [
          {
            name = "org-wiki-memory";
            source = {
              source = "local";
              path = "./plugins/org-wiki-memory";
            };
            policy = {
              installation = "AVAILABLE";
              authentication = "ON_INSTALL";
            };
            category = "Productivity";
          }
        ];
      };
      manifest = json "plugin.json" {
        name = "org-wiki-memory";
        version = "0.1.2";
        description = "Search and maintain project decisions and personal preferences in your local Org wiki.";
        mcpServers = "./.mcp.json";
        requires_local_executor = true;
        interface.displayName = "Org Wiki Memory";
      };
      mcp = json "mcp.json" {
        mcpServers.org_wiki_desktop = {
          # 服务由常驻的 org-wiki-mcp 代理暴露，这里只连地址。
          type = "streamable-http";
          url = orgWikiMcp.url;
        };
      };
      marketplaceDir = "${config.xdg.dataHome}/org-wiki-chatgpt";
    in
    {
      # The installer canonicalizes the catalog root and copies only regular plugin files.
      home.activation.chatgptOrgWikiMemory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        plugin="${marketplaceDir}/plugins/org-wiki-memory"
        run ${pkgs.coreutils}/bin/install -Dm444 ${catalog} "${marketplaceDir}/.agents/plugins/marketplace.json"
        run ${pkgs.coreutils}/bin/install -Dm444 ${manifest} "$plugin/.codex-plugin/plugin.json"
        run ${pkgs.coreutils}/bin/install -Dm444 ${mcp} "$plugin/.mcp.json"
        run ${pkgs.llm-agents.codex}/bin/codex plugin marketplace add "${marketplaceDir}"
        run ${pkgs.llm-agents.codex}/bin/codex plugin add org-wiki-memory@org-wiki-local
      '';
      home.packages = lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.llm-agents.chatgpt;
    };
}
