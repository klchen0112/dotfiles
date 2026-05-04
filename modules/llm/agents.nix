{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };
  den.aspects.hermes = {
    nixos = {
      imports = with inputs; [
        hermes-agent.nixosModules.default
      ];
      # configuration.nix
      services.hermes-agent = {
        enable = true;
        # settings.model.default = "anthropic/claude-sonnet-4";
        addToSystemPackages = true;
      };

    };
  };
  den.aspects.llm-agents = {
    llm-agents =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          inputs.llm-agents.overlays.default
        ];

        nix.settings = {
          extra-substituters = [
            "https://cache.numtide.com"
          ];
          extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
        home.packages =
          with pkgs;
          [
            llm-agents.opencode
            llm-agents.hermes-agent
            # llm-agents.gemini-cli
          ]
          ++ (with pkgs.python314Packages; [
            python-telegram-bot
          ]);
      };
  };
}
