{ den, inputs, ... }:
{
  flake-file.inputs = {
    llama-cpp = {
      # url = "github:ggml-org/llama.cpp";
      # url = "github:acerspyro/beellama.cpp";
      url = "github:EsmaeelNabil/llama.cpp-mtp-turbo-quant/feat/mtp-turboquant-kv-cache";
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
            Description = "llama-server: local LLM inference server (Carnice-Qwen3.6-MoE-35B-A3B-APEX)";
            After = [ "network.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 5;
            ExecStart = pkgs.writeShellScript "run-llama-server" ''
              #!/usr/bin/env bash
              export MODEL_DIR=${config.home.homeDirectory}/.cache/modelscope/hub/models/mudler/Carnice-Qwen3.6-MoE-35B-A3B-APEX-GGUF
              export MMPROJ=${config.home.homeDirectory}/.cache/modelscope/hub/models/mudler/Qwen3.6-35B-A3B-APEX-GGUF/mmproj.gguf
              ${pkgs.llama-cpp}/bin/llama-server \
                -mm "$MMPROJ" \
                -m $MODEL_DIR/Carnice-Qwen3.6-MoE-35B-A3B-APEX-I-Compact.gguf \
                --alias Carnice-Qwen3.6-MoE-35B-A3B-APEX \
                --parallel 1 \
                --ctx-size 262144 \
                --flash-attn on \
                --jinja \
                --chat-template-kwargs '{"preserve_thinking": true}' \
                --reasoning on \
                --reasoning-budget 4096 \
                --temp 0.6 \
                --top-k 20 \
                --top-p 0.95 \
                --min-p 0 \
                --spec-type draft \
                --spec-draft-n-max 2 \
                -ctk turbo4 \
                -ctv turbo4 \
                --host 0.0.0.0
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

          Service =
            let
              llama-cpp = pkgs.llama-cpp;
              mmproj = "${config.home.homeDirectory}/model/mudler/Qwopus3.6-35B-A3B-v1-APEX-MTP-GGUF/mmproj-BF16.gguf";
              model-path = "${config.home.homeDirectory}/model/mudler/Qwopus3.6-35B-A3B-v1-APEX-MTP-GGUF/Qwopus3.6-35B-A3B-v1-APEX-MTP-I-Compact.gguf";
              model-name = "Qwopus3.6-35B-A3B-v1-APEX-MTP-I-Compact";
              template-file = "${config.home.homeDirectory}/model/Jackrong/Qwopus3.6-27B-v2-MTP-GGUF/chat_template.jinja";
              ctx-size = "128000";
            in
            {
              Type = "simple";
              Restart = "on-failure";
              RestartSec = 5;
              ExecStart = pkgs.writeShellScript "run-llama-server-rocm" ''
                #!/usr/bin/env bash
                ${llama-cpp}/bin/llama-server -m ${model-path} -mm ${mmproj} --alias ${model-name} --host 0.0.0.0 --flash-attn on --temp 0.6 --top-k 20 --top-p 0.95 --min-p 0 -ctk q8_0 -ctv turbo3 --chat-template-kwargs '{"preserved_thinking":true}' -c ${ctx-size} --jinja --chat-template-file ${template-file} --spec-type mtp --spec-draft-n-max 5  --spec-draft-p-min 0.75 -kvu -np 1 -ctkd q8_0 -ctvd turbo2 --reasoning off
              '';
            };

          Install.WantedBy = [ "default.target" ];
        };
      };
  };

}
