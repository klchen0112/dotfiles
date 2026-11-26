{ den, ... }:
let
  # vLLM 0.34.0 serves both pooling models and includes the VL scoring template.
  vllmImage = "vllm/vllm-openai@sha256:20fdb089454afbb324efa4110a2c025ff7b27cc1a086e07aa580b18df8ad1ce1";
  network = "llm-inference";
  gatewayPort = 8000;
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
      matchPaths =
        method:
        map (path: {
          inherit method;
          path.exact = path;
        });

      gatewayConfig = (pkgs.formats.yaml { }).generate "agentgateway.yaml" {
        # This gateway only serves HTTP inference. Keep the config mount read-only.
        config.session.key = "disabled";
        gateways.default = {
          port = gatewayPort;
          apiKey = {
            mode = "strict";
            # Expanded by agentgateway from the existing Docker env file.
            keys = [ { key = "$LITELLM_MASTER_KEY"; } ];
          };
        };
        routes = [
          {
            name = "embeddings";
            matches = matchPaths "POST" [
              "/embeddings"
              "/v1/embeddings"
              "/gemma/v1/embeddings"
            ];
            # Preserve vLLM's native multimodal "messages" body as well as "input".
            policies.urlRewrite.path.full = "/v1/embeddings";
            backends = [ { host = "vllm:8000"; } ];
          }
          {
            name = "rerank";
            matches = matchPaths "POST" [
              "/rerank"
              "/v1/rerank"
              "/v2/rerank"
            ];
            backends = [ { host = "vllm-reranker:8000"; } ];
          }
          {
            name = "models";
            matches = matchPaths "GET" [
              "/models"
              "/v1/models"
            ];
            policies.directResponse = {
              status = 200;
              headers."content-type" = ''"application/json"'';
              body = builtins.toJSON {
                object = "list";
                data =
                  map
                    (id: {
                      inherit id;
                      object = "model";
                      created = 0;
                      owned_by = "vllm";
                    })
                    [
                      vllm.servedName
                      reranker.servedName
                    ];
              };
            };
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

      networking.firewall.allowedTCPPorts = [ gatewayPort ];
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
        containers.agentgateway = {
          image = "cr.agentgateway.dev/agentgateway:v1.7.0@sha256:60216aafb03d37f94e952ff3d51d2f630a65b10ecaebdc0a864882f92610c45b";
          environmentFiles = [ "/home/klchen/.config/litellm/router.env" ];
          volumes = [ "${gatewayConfig}:/etc/agentgateway.yaml:ro" ];
          cmd = [
            "-f"
            "/etc/agentgateway.yaml"
          ];
          networks = [ network ];
          ports = [ "${toString gatewayPort}:${toString gatewayPort}" ];
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
      // lib.genAttrs [ "docker-vllm" "docker-vllm-reranker" "docker-agentgateway" ] (_: {
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
