{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.hermes = {
    nixos =
      { pkgs, config, ... }:
      {
        imports = with inputs; [
          hermes-agent.nixosModules.default
        ];
        nixpkgs.overlays = [
          inputs.llm-agents.overlays.default
        ];
        # configuration.nix
        services.hermes-agent = {
          enable = true;
          # container.enable = true;
          settings = {
            model.default = "mudler/Carnice-Qwen3.6-MoE-35B-A3B-APEX";
            memory = {
              memory_enabled = true;
              user_profile_enabled = true;
            };
            terminal = {
              backend = "local";
              timeout = 180;
            };
          };
          # environmentFiles = [ config.sops.secrets."hermes-env".path ];
          addToSystemPackages = false;
        };
      };
  };
  den.aspects.llm-agents = {
    llm-agents =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          inputs.llm-agents.overlays.default
          inputs.hermes-agent.overlays.default
        ];

        nix.settings = {
          extra-substituters = [
            "https://cache.numtide.com"
          ];
          extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "cache.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
        home.packages = with pkgs; [
         hermes-agent
          # llm-agents.opencode
          # opencode
        ];
      };
  };
}
