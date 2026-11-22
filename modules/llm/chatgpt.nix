{
  den,
  ...
}:
{
  # OpenAI 官方 ChatGPT / Codex 桌面应用（https://developers.openai.com/codex/app）。
  #
  # Linux：nixpkgs 的 pkgs.chatgpt 就是官方 deb 的重打包（unfree）。
  # macOS：走 homebrew cask（见 modules/homebrew/default.nix，brew-nix 里也有
  #         chatgpt 这个 cask）。不用 pkgs.chatgpt 是因为 cask 装的是
  #         /Applications 里的真包，能正常自更新。
  den.aspects.chatgpt.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
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
        version = "0.1.1";
        description = "Search and maintain project decisions and personal preferences in your local Org wiki.";
        mcpServers = "./.mcp.json";
        requires_local_executor = true;
        interface.displayName = "Org Wiki Memory";
      };
      mcp = json "mcp.json" {
        mcpServers.org_wiki_desktop = {
          command = "${pkgs.local.org-wiki-memory}/bin/org-wiki-memory";
          args = [ "${config.home.homeDirectory}/open/org-wiki" ];
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
