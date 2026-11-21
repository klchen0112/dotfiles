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
    { pkgs, lib, ... }:
    {
      home.packages = lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.llm-agents.chatgpt;
    };
}
