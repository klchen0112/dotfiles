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
      services.ollamah= {
        enable = false;
        package=pkgs.stable.ollama-cuda;
        port = 11111;
      };
    };
}
