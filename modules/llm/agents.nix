{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.llm-agents = {
    llm-agents = { pkgs, ... }: {
      nixpkgs.overlays = [
        inputs.llm-agents.overlays.shared-nixpkgs
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
      programs.opencode = {
        enable = false;
        package = pkgs.llm-agents.opencode;
      };
      home.packages = with pkgs; [
        # graphify
        # hermes-agent is provided by programs.hermes-agent (home-manager module) above
        # opencode
      ];
    };
  };
}
