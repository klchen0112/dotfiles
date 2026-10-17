{ den, ... }:
let
  # ── Strata server definition (edit here) ─────────────────────────────
  # Strata (https://github.com/Niko1221/Strata) runs Qwen3.8-Flash-Next /
  # Swift 1.5 GGUFs on a single NVIDIA GPU, exposed as an OpenAI-compatible
  # API on :8080/v1. The image is built from source, not pulled from a
  # registry:
  #   git clone https://github.com/Niko1221/Strata && cd Strata
  #   docker build -t strata .
  strata = {
    image = "strata"; # local image built from the Strata repo
    family = "swift";
    model = "IQ2_XS";
    kv = "k8v4"; # INT8 K + 4-bit V, keeps KV in VRAM from 64K up
    context = "262144";
    port = 8080;
    # local GGUF checkout mounted as the container's /data
    modelDir = "/home/klchen/Strata-data/";
    # run the container as klchen's uid/gid so the files it writes into the
    # /data bind mount (config, pack, mtp) are klchen's, not root's. The image
    # owns /opt/strata as 1000:100 too, so the config symlink, __pycache__ and
    # the engine log land on the same uid.
    uid = 1000;
    gid = 100;
  };
in
{
  # docker daemon + NVIDIA Container Toolkit (CDI) + firewall port 8080 are
  # already enabled on a99r50 by the `k3s-nvidia` aspect and the host's
  # `networking.firewall.allowedTCPPorts = [ 8080 ]`.
  den.aspects.llm-strata.nixos =
    { lib, ... }:
    {
      virtualisation.oci-containers = {
        backend = "docker";
        containers.strata = {
          image = strata.image;
          ports = [ "${toString strata.port}:${toString strata.port}" ];
          volumes = [ "${strata.modelDir}:/data" ];
          environment = {
            FAMILY = strata.family;
            MODEL = strata.model;
            KV = strata.kv;
            CONTEXT = strata.context;
            VISION = "yes";
            STRATA_PIN_BY_NEED = "1";
          };
          # CDI device path: the nvidia-container-toolkit generates
          # /var/run/cdi/nvidia-container-toolkit.json on boot
          devices = [ "nvidia.com/gpu=all" ];
          # docker run --rm is the default (autoRemoveOnStop), so only the
          # ulimit needs to be carried over here. Each list element is passed
          # as a separate argv token, so `--ulimit` and its value must be split.
          extraOptions = [
            # each element is passed as its own argv token
            "--user"
            "${toString strata.uid}:${toString strata.gid}"
            "--ulimit"
            "memlock=-1"
          ];
        };
      };

      # long-running server: never time out the (first) start, keep it up
      systemd.services."docker-strata".serviceConfig = {
        TimeoutStartSec = 0;
        # oci-containers sets "on-failure"; a server should always come back
        Restart = lib.mkForce "always";
        RestartSec = 15;
      };
    };
}
