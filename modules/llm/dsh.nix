{ den, inputs, ... }:
{
  den.aspects.dsh = {
    dsh =
      {
        pkgs,
        lib,
        config,
        inputs,
        ...
      }:
      {
        #imports = with inputs; [
        #  dsh-nix.homeManagerModules.dsh
        #];
        #nixpkgs.overlays = with inputs; [
        #  dsh-nix.overlays.default
        #];
        #programs.dsh = {
        #  enable = true;
        #  profiles.headless = {
        #    plugins = [ "@deepseek-ai/dsh-base" "@deepseek-ai/dsh-headless" ];
        #  };
        #  profiles.web = {
        #    plugins = [ "@deepseek-ai/dsh-base" "@deepseek-ai/dsh-web-app" ];
        #  };
        #};
        home.packages = with pkgs; [

          llm-agents.dsh
        ];
      };
  };
}
