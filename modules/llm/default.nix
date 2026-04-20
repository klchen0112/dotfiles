{ den, inputs, ... }:
{
  flake-file.inputs = {
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
    };
  };
  den.aspects.llm = {
    llm =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          inputs.llama-cpp.overlays.default
          inputs.llm-agents.overlays.default
        ];

        nixpkgs = {
          config = {
            cudaSupport = true;
          };
        };

        nix.settings = {
          extra-substituters = [
            "https://cache.numtide.com"
            "https://cuda-maintainers.cachix.org"
          ];
          extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="

          ];
        };
        home.packages =
          with pkgs;
          [
#            llm-agents.opencode
            llamaPackages.llama-cpp
            nvtopPackages.nvidia
          ]
          ++ (with pkgs.python314Packages; [
            hf-xet
            huggingface-hub
            modelscope
          ]);
      };
  };
}
