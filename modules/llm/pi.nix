{ den, inputs, ... }:
{
  flake-file.inputs = {
    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.pi = {
    pi =
      {
        pkgs,
        lib,
        config,
        inputs,
        ...
      }:
      {
        imports = with inputs; [
          pi.homeModules.default
        ];
        programs.pi.coding-agent = {
          enable = true;
          models = ./models.json;
          settings.model = "Ornith-1.5-35B-A3B-ROCmFP4";
          # rules = ''Be concise.'';
          # skills = [ ./skills/my-skill ];
          # models = ./models.json;
          # settings.model = "gpt-5";
          # environment.PI_CODING_AGENT_DIR.value = "${config.home.homeDirectory}/.pi/agent";
          # environment.OPENAI_API_KEY.file = config.sops.secrets.openai-api-key.path;
        };

      };
  };
}
