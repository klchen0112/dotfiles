{ den, inputs, ... }:
{
  flake-file.inputs = {
    llama-cpp = {
      # url = "github:ggml-org/llama.cpp";
      url = "github:Anbeeld/beellama.cpp";
      # url = "github:spiritbuun/buun-llama-cpp";
      # url = "github:TheTom/llama-cpp-turboquant";
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
            cudaVersion = "13";
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
            llama-cpp
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
            Description = "llama-server: local LLM inference server";
            After = [ "network.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 5;
            ExecStart = pkgs.writeShellScript "run-llama-server" ''
              #!/usr/bin/env bash
              export MODEL_DIR=${config.home.homeDirectory}/model/Ornith-1.0-9B-NVFP4-MTP-GGUF
              ${pkgs.llama-cpp}/bin/llama-server   -m $MODEL_DIR/ornith-1.0-9b-NVFP4-MTP.gguf --port 8080 --no-mmap --mlock   --jinja -fa on -ngl 99   --chat-template-file $MODEL_DIR/chat_template.jinja   --spec-type draft-mtp   --spec-draft-n-max 3   --temp 0.9 --top-p 0.95 --top-k 20 --min-p 0.01 --repeat-penalty 1.1 --alias Ornith-1.0-9B-NVFP4-MTP-GGUF
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

        # llama-server systemd user service (rocm)
        systemd.user.services.llama-server-rocm = {
          Unit = {
            Description = "llama-server: local LLM inference server (Carnice-Qwen3.6-MoE-35B-A3B-APEX-MTP)";
            After = [ "network.target" ];
          };

          Service =
            let
              llama-cpp = pkgs.llama-cpp;
              model-dir = "${config.home.homeDirectory}/model/LuffyTheFox/Qwen3.6-35B-A3B-Uncensored-Genesis-Hermes-V6-GGUF";
              mmproj = "${model-dir}/mmproj-Hermes3.6-35B-A3B-Uncensored-Genesis-F16.gguf";
              model-path = "${model-dir}/Hermes3.6-35B-A3B-Uncensored-Genesis-V7-MTP-APEX-Compact.gguf";
              model-name = "LuffyTheFox-Qwen3.6-35B-A3B-Uncensored-Genesis-Hermes-V6-GGUF";
              template-file = "${config.home.homeDirectory}/.cache/modelscope/hub/models/froggeric/Qwen-Fixed-Chat-Templates/chat_template.jinja";
              ctk = "q8_0";
              ctv = "q6_0";
              ctx-size = "131077";
            in
            {
              Type = "simple";
              Restart = "on-failure";
              RestartSec = 5;
              ExecStart = pkgs.writeShellScript "run-llama-server-rocm" ''
                                #!/usr/bin/env bash
                                ${llama-cpp}/bin/llama-server \
                                 -m ${model-path} \
                                 -mm ${mmproj} \
                                 -ctk ${ctk} -ctv ${ctv} \
                                 --host 0.0.0.0\
                                 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 \
                                 --jinja --chat-template-file ${template-file} \
                                 --alias ${model-name} \
                                 -fa on -kvu \
                                 --parallel 1\
                                 --spec-type draft-mtp --spec-draft-n-max 2
              '';
            };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };

  den.aspects.llm-deploy-vulkan = {
    llm-deploy-vulkan =
      { pkgs, config, ... }:
      let
      in
      {
        nixpkgs.overlays = [
          inputs.llama-cpp.overlays.default
        ];

        nixpkgs = {
          config = {
            vulkanSupport = true;
          };
        };
        home.packages =
          with pkgs;
          [
            vulkan-loader
            vulkan-headers
            vulkan-tools
            vulkan-validation-layers
            llama-cpp
          ]
          ++ (with pkgs.python314Packages; [
            hf-xet
            huggingface-hub
            modelscope
          ]);

        # llama-server systemd user service (vulkan)
        systemd.user.services.llama-server-vulkan = {
          Unit = {
            Description = "llama-server: local LLM inference server (Ornith-1.0-35B-MTP-APEX-I-Compact-Vulkan)";
            After = [ "network.target" ];
          };

          Service =
            let
              llama-cpp = pkgs.llama-cpp.override { useVulkan = true; };
              mmproj = "${config.home.homeDirectory}/model/LuffyTheFox/Qwen3.6-35B-A3B-Uncensored-Genesis-Hermes-V6-GGUF/mmproj-Hermes3.6-35B-A3B-Uncensored-Genesis-F16.gguf";
              model-path = "${config.home.homeDirectory}/model/LuffyTheFox/Qwen3.6-35B-A3B-Uncensored-Genesis-Hermes-V6-GGUF/Hermes3.6-35B-A3B-Uncensored-Genesis-V6-APEX-Compact.gguf";
              model-name = "Qwen3.6-35B-A3B-Uncensored-Genesis-Hermes-V6-GGUF";
              template-file = "${config.home.homeDirectory}/.cache/modelscope/hub/models/froggeric/Qwen-Fixed-Chat-Templates/chat_template.jinja";
              ctk = "kvarn6";
              ctv = "kvarn6";
              ctx-size = "131077";
            in
            {
              Type = "simple";
              Restart = "on-failure";
              RestartSec = 5;
              ExecStart = pkgs.writeShellScript "run-llama-server-vulkan" ''
                                #!/usr/bin/env bash
                                ${llama-cpp}/bin/llama-server \
                                 -m ${model-path} \
                                 -mm ${mmproj} \
                                 --kv-tail-tokens 1024\
                                 --host 0.0.0.0\
                                 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 \
                                 --jinja --chat-template-file ${template-file} \
                                 --alias ${model-name} \
                                 -ctk ${ctk} -ctv ${ctv} -fa on\
                                 -ngl all \
                                 --cache-ram 2048 -b 2048 -ub 1024\
                	               --cache-prompt 
              '';
            };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };

}
