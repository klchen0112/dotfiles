{ den, ... }:
let
  # vLLM 0.34.0 serves both pooling models and includes the VL scoring template.
  vllmImage = "vllm/vllm-openai@sha256:20fdb089454afbb324efa4110a2c025ff7b27cc1a086e07aa580b18df8ad1ce1";
  network = "llm-inference";
  routerPort = 8000;
  vllm = {
    modelscopeCacheDir = "/home/klchen/.cache/modelscope";
    # ModelScope keeps the actual model files below snapshots/master.
    model = "/root/.cache/modelscope/models/google--embeddinggemma-2/snapshots/master";
    servedName = "embeddinggemma-2";
  };
  reranker = {
    modelDir = "${vllm.modelscopeCacheDir}/models/Qwen--Qwen3-VL-Reranker-2B/snapshots/master";
    servedName = "Qwen3-VL-Reranker-2B";
  };
in
{
  den.aspects.llm-vllm.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      routerConfig = (pkgs.formats.yaml { }).generate "litellm.yaml" {
        # LiteLLM's OpenAI embeddings endpoint requires "input". Preserve the
        # native vLLM request format ("messages" with images, audio or video).
        general_settings.pass_through_endpoints = [
          {
            path = "/gemma/v1/embeddings";
            target = "http://vllm:8000/v1/embeddings";
            methods = [ "POST" ];
          }
        ];
        model_list = [
          {
            model_name = vllm.servedName;
            litellm_params = {
              model = "hosted_vllm/${vllm.servedName}";
              api_base = "http://vllm:8000/v1";
            };
            model_info.mode = "embedding";
          }
          {
            model_name = reranker.servedName;
            litellm_params = {
              model = "hosted_vllm/${reranker.servedName}";
              api_base = "http://vllm-reranker:8000";
            };
            model_info.mode = "rerank";
          }
        ];
      };
    in
    {
      # ── docker + NVIDIA GPU access for containers ─────────────────────
      virtualisation.docker.enable = true;
      # generates /var/run/cdi/nvidia-container-toolkit.json on boot;
      # containers reach the GPU via `--device nvidia.com/gpu=all`
      hardware.nvidia-container-toolkit.enable = true;

      users.users.klchen.extraGroups = [ "docker" ];

      networking.firewall.allowedTCPPorts = [ routerPort ];
      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
      ];
      # ── `vllm serve` as a systemd service ─────────────────────────────
      virtualisation.oci-containers = {
        backend = "docker";
        containers.vllm = {
          image = vllmImage;
          networks = [ network ];
          # the image entrypoint is already `vllm serve`, cmd is appended to it
          cmd = [
            vllm.model
            "--runner"
            "pooling"
            "--served-model-name"
            vllm.servedName
            "--host"
            "0.0.0.0"
            "--port"
            "8000"
            "--dtype"
            "bfloat16"
            "--attention-backend"
            "TRITON_ATTN"
            # Permit either service to start while the other is resident.
            "--gpu-memory-utilization"
            "0.30"
            "--max-num-seqs"
            "8"
          ];
          volumes = [
            "${vllm.modelscopeCacheDir}:/root/.cache/modelscope:ro"
          ];
          environment = {
            HF_HUB_OFFLINE = "1";
            VLLM_USE_MODELSCOPE = "true";
            MODELSCOPE_CACHE = "/root/.cache/modelscope";
          };
          devices = [ "nvidia.com/gpu=all" ];
          # --ipc=host is what the vLLM docker docs recommend
          extraOptions = [
            "--ipc=host"
          ];
        };
        containers.vllm-reranker = {
          image = vllmImage;
          networks = [ network ];
          cmd = [
            "/model"
            "--served-model-name"
            reranker.servedName
            "--runner"
            "pooling"
            "--hf-overrides"
            (builtins.toJSON {
              architectures = [ "Qwen3VLForSequenceClassification" ];
              classifier_from_token = [
                "no"
                "yes"
              ];
              is_original_qwen3_reranker = true;
            })
            "--chat-template"
            "/vllm-workspace/examples/pooling/score/template/qwen3_vl_reranker.jinja"
            "--dtype"
            "bfloat16"
            "--attention-backend"
            "TRITON_ATTN"
            "--max-model-len"
            "4096"
            "--max-num-seqs"
            "1"
            "--gpu-memory-utilization"
            "0.50"
            "--enforce-eager"
          ];
          volumes = [ "${reranker.modelDir}:/model:ro" ];
          environment.HF_HUB_OFFLINE = "1";
          devices = [ "nvidia.com/gpu=all" ];
          extraOptions = [ "--ipc=host" ];
        };
        containers.llm-router = {
          image = "ghcr.io/berriai/litellm@sha256:ef798594ca3db8d81bad2e1439f536f49b71fe095ee9f20416f5e149b4e22035";
          environmentFiles = [ "/home/klchen/.config/litellm/router.env" ];
          volumes = [ "${routerConfig}:/etc/litellm.yaml:ro" ];
          cmd = [
            "--config"
            "/etc/litellm.yaml"
            "--port"
            "8000"
          ];
          networks = [ network ];
          ports = [ "${toString routerPort}:8000" ];
        };
      };

      # long-running server: never time out the (first) image pull, keep it up
      systemd.services = {
        llm-network = {
          requires = [ "docker.service" ];
          after = [ "docker.service" ];
          path = [ config.virtualisation.docker.package ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            docker network inspect ${network} >/dev/null 2>&1 || docker network create ${network}
          '';
        };
      }
      // lib.genAttrs [ "docker-vllm" "docker-vllm-reranker" "docker-llm-router" ] (_: {
        requires = [ "llm-network.service" ];
        after = [ "llm-network.service" ];
        serviceConfig = {
          TimeoutStartSec = 0;
          # oci-containers sets "on-failure"; a server should always come back
          Restart = lib.mkForce "always";
          RestartSec = 15;
        };
      });
    };
}
