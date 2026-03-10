{
  flake.modules.homeManager.llm =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          llama-cpp
          vllm
          # nvtopPackages.nvidia
        ]
        ++ (with pkgs.python313Packages; [
          hf-xet
          huggingface-hub
        ]);
      services.ollama= {
        enable = false;
        port = 11111;
      };
    };
}
