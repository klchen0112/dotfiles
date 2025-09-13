{
  flake.modules.homeManager.web =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodejs
        typescript-language-server
        emmet-ls
        jsonnet-language-server
        yaml-language-server
        # nodePackages.npm
        # nodePackages.pnpm
        # nodePackages.eslint
        # nodePackages.typescript
        # nodePackages.typescript-language-server
        # nodePackages.javascript-typescript-langserver
        # emmet-ls
      ];
    };
}
