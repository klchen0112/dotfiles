{ den, ... }:
let
  # ── vLLM server definition (edit here) ────────────────────────────────
  vllm = {
    # pinned release image (the model card needs vLLM ≥ 0.19.1)
    image = "vllm/vllm-openai:v0.29.0";
    # HF repo id served by `vllm serve` (NVFP4 quant build: bf16 is 19.3 GB
    # and does not fit the 16 GB card; same weights, ~8.8 GB on disk)
    model = "ornith-ai/Ornith-1.5-9B-NVFP4";
    servedName = "Ornith-1.5-9B";
    port = 8000;
    maxModelLen = "131072";
    cacheDir = "/home/klchen/.cache/huggingface";
    modelscopeCacheDir = "/home/klchen/.cache/modelscope";
    # docker --env-file for this container; edit it to flip the download source
    # at runtime (no rebuild): systemctl restart docker-vllm
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
      # cachyos kernels come from the nix-cachyos-kernel flake, built with its
      # own pinned nixpkgs. Its glibc can differ from the system's, so mount it
      # too: the injected nvidia executables (nvidia-smi, ...) link against it
      # and otherwise fail with "cannot execute: required file not found".
      driverGlibc = config.boot.kernelPackages.stdenv.cc.libc or pkgs.glibc;
    in
    {
      # ── docker + NVIDIA GPU access for containers ─────────────────────
      virtualisation.docker.enable = true;
      # generates /var/run/cdi/nvidia-container-toolkit.json on boot;
      # containers reach the GPU via `--device nvidia.com/gpu=all`
      hardware.nvidia-container-toolkit.enable = true;
      hardware.nvidia-container-toolkit.mounts = [
        {
          hostPath = "${driverGlibc}";
          containerPath = "${driverGlibc}";
        }
      ];

      users.users.klchen.extraGroups = [ "docker" ];

      networking.firewall.allowedTCPPorts = [ vllm.port ];
      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
      ];
      # ── `vllm serve` as a systemd service ─────────────────────────────
      virtualisation.oci-containers = {
        backend = "docker";
        containers.vllm = {
          image = vllm.image;
          # the image entrypoint is already `vllm serve`, cmd is appended to it
          cmd = [
            "--model"
            vllm.model
            "--served-model-name"
            vllm.servedName
            "--host"
            "0.0.0.0"
            "--port"
            (toString vllm.port)
            "--max-model-len"
            vllm.maxModelLen
            # bf16 KV for 262144 tokens is 8 GiB; the quant config ships FP8 KV
            "--kv-cache-dtype"
            "auto"
            "--enable-prefix-caching"
            "--enable-auto-tool-choice"
            "--tool-call-parser"
            "qwen3_xml"
            "--reasoning-parser"
            "qwen3"
            "--trust-remote-code"
          ];
          ports = [ "${toString vllm.port}:${toString vllm.port}" ];
          volumes = [
            "${vllm.cacheDir}:/root/.cache/huggingface"
            "${vllm.modelscopeCacheDir}:/root/.cache/modelscope"
          ];
          environment = {
            VLLM_USE_MODELSCOPE = "true";
            HF_HOME = "/root/.cache/huggingface";
            MODELSCOPE_HOME = "/root/.cache/huggingface";
          };
          # runtime switch for the download source (VLLM_USE_MODELSCOPE=true
          # makes vllm resolve --model through modelscope.snapshot_download,
          # using MODELSCOPE_CACHE=/root/.cache/modelscope)
          devices = [ "nvidia.com/gpu=all" ];
          # --ipc=host is what the vLLM docker docs recommend
          extraOptions = [ "--ipc=host" ];
        };
      };

      # long-running server: never time out the (first) image pull, keep it up
      systemd.services."docker-vllm".serviceConfig = {
        TimeoutStartSec = 0;
        # oci-containers sets "on-failure"; a server should always come back
        Restart = lib.mkForce "always";
        RestartSec = 15;
      };
    };
}
