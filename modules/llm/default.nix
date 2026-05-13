{ den, inputs, ... }:
{
  flake-file.inputs = {
    llama-cpp = {
      # url = "github:ggml-org/llama.cpp";
      # url = "github:acerspyro/beellama.cpp";
      url = "github:am17an/llama.cpp/mtp-clean";
      inputs.nixpkgs.follows = "nixpkgs";

    };
  };
  den.aspects.llm-deploy = {
    llm-deploy =
      { pkgs, config, ... }:
      {
        nixpkgs.overlays = [
          inputs.llama-cpp.overlays.default
        ];

        nixpkgs = {
          config = {
            cudaSupport = true;
          };
        };

        nix.settings = {
          extra-substituters = [
            "https://cuda-maintainers.cachix.org"
          ];
          extra-trusted-public-keys = [
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
          ];
        };
        home.packages =
          with pkgs;
          [
            llamaPackages.llama-cpp
            nvtopPackages.nvidia
          ]
          ++ (with pkgs.python314Packages; [
            hf-xet
            huggingface-hub
            modelscope
          ]);

        # llama-server systemd user service
        systemd.user.services.llama-server = {
          Unit = {
            Description = "llama-server: local LLM inference server (Carnice-Qwen3.6-MoE-35B-A3B-APEX)";
            After = [ "network.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 5;
            ExecStart = pkgs.writeShellScript "run-llama-server" ''
              #!/usr/bin/env bash
              export MODEL=${config.home.homeDirectory}/.cache/modelscope/hub/models/mudler/Carnice-Qwen3.6-MoE-35B-A3B-APEX-GGUF/Carnice-Qwen3.6-MoE-35B-A3B-APEX-I-Compact.gguf
              export MMPROJ=${config.home.homeDirectory}/.cache/modelscope/hub/models/mudler/Qwen3.6-35B-A3B-APEX-GGUF/mmproj.gguf

              exec ${pkgs.llamaPackages.llama-cpp}/bin/llama-server \
                -m "$MODEL" \
                --host 0.0.0.0 \
                --spec-default \
                --temp 1.0 \
                --min-p 0.0 \
                --top-p 0.95 \
                --top-k 20 \
                --presence_penalty 1.5 \
                -mm "$MMPROJ" \
                --alias "mudler/Carnice-Qwen3.6-MoE-35B-A3B-APEX" \
                --spec-type ngram-mod \
                --spec-ngram-mod-n-match 24 \
                --spec-ngram-mod-n-min 48 \
                --spec-ngram-mod-n-max 64 \
                -c 262144 
            '';

            StandardOutput = "journal";
            StandardError = "journal";
          };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };
  den.aspects.llm-deploy-rocm = {
    llm-deploy-rocm =
      { pkgs, config, ... }:
      {
        nixpkgs.overlays = [
          inputs.llama-cpp.overlays.default
        ];

        nixpkgs = {
          config = {
            rocmSupport = true;
          };
        };
        home.packages =
          with pkgs;
          [
            llama-cpp
            nvtopPackages.amd
          ]
          ++ (with pkgs.python314Packages; [
            hf-xet
            huggingface-hub
            modelscope
          ]);

        # llama-server systemd user service
        systemd.user.services.llama-server = {
          Unit = {
            Description = "llama-server: local LLM inference server (Carnice-Qwen3.6-MoE-35B-A3B-APEX)";
            After = [ "network.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 5;
            ExecStart = pkgs.writeShellScript "run-llama-server-rocm" ''
              #!/usr/bin/env bash
              export MODEL=${config.home.homeDirectory}/.cache/modelscope/hub/models/unsloth/Qwen3.6-27B-GGUF-MTP/Qwen3.6-27B-IQ4_NL.gguf
              export MMPROJ=${config.home.homeDirectory}/.cache/modelscope/hub/models/unsloth/Qwen3.6-27B-GGUF-MTP/mmproj-BF16.gguf
              exec ${pkgs.llama-cpp}/bin/llama-server -m "$MODEL" -mm "$MMPROJ"  -c 80000 -fa on -np 1   --spec-type draft-mtp --spec-draft-n-max 3 --host 0.0.0.0 --temp 1.0     --top-p 0.95     --top-k 20     --presence-penalty 1.5  --min-p 0.00  --n-gpu-layers 99 --kv-unified --cache-type-k q8_0 --cache-type-v q8_0 --n-cpu-moe 4 --no-mmap --batch-size 4096 --ubatch-size 256 \
                --alias "unsloth/Qwen3.6-27B-GGUF-MTP" 
            '';

            StandardOutput = "journal";
            StandardError = "journal";
          };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };

}
