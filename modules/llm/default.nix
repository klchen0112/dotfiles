{
  flake.modules.nixos.llm =
    { pkgs, ... }:
    {
    };

  flake.modules.homeManager.llm =
    { pkgs, ... }:
    {
      nixpkgs = {
        config = {
          cudaSupport = true;
        };
      };

      home.packages =
        with pkgs;
        [
          (llama-cpp.override {
            cudaSupport = true;
          })
          ollama-cuda
          nvtopPackages.nvidia
        ]
        ++ (with pkgs.python314Packages; [
          hf-xet
          huggingface-hub
          modelscope
        ]);
      services.ollama = {
        enable = true;
        acceleration = "cuda";
      };
    };
}
