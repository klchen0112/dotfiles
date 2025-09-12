{
  flake.modules.homeManager.web =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodejs
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
