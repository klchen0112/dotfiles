{ inputs, ... }:
{
  flake-file.inputs.pi-config = {
    url = "github:klchen0112/pi-config";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  den.aspects.pi = {
    pi =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        authFile = ../../secrets/klchen/pi-auth.json;
        authRevision = builtins.hashFile "sha256" authFile;
        authSecret = "pi-auth-${authRevision}";
        deployAuth = pkgs.writeShellScript "deploy-pi-auth" ''
          set -euo pipefail
          export PATH=${lib.makeBinPath [ pkgs.coreutils ]}
          umask 077

          sourceFile=${lib.escapeShellArg config.sops.secrets.${authSecret}.path}
          agentDir=${lib.escapeShellArg config.programs.pi.coding-agent.environment.PI_CODING_AGENT_DIR.value}
          destination="$agentDir/auth.json"
          revisionFile="$agentDir/.sops-auth-revision"
          revision=${authRevision}

          # Pi refreshes credentials in place. Install only once per ciphertext revision.
          authIsCurrent() {
            [[ -f "$destination" && ! -L "$destination" && -f "$revisionFile" ]] \
              && [[ $(< "$revisionFile") == "$revision" ]]
          }
          if authIsCurrent; then
            exit 0
          fi

          ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
            # launchd starts sops-nix asynchronously during Home Manager activation.
            for ((attempt = 0; attempt < 100; attempt++)); do
              if [[ -r "$sourceFile" ]]; then
                break
              fi
              sleep 0.1
            done
          ''}
          if [[ ! -r "$sourceFile" ]]; then
            echo 'Pi auth: sops-nix did not install the expected secret.' >&2
            exit 1
          fi

          mkdir -p -- "$agentDir"
          lockDir="$destination.lock"
          for ((attempt = 1; ; attempt++)); do
            mkdir -- "$lockDir" 2>/dev/null && break
            if ((attempt == 100)); then
              echo 'Pi auth: could not acquire the credential file lock.' >&2
              exit 1
            fi
            sleep 0.1
          done
          trap 'rm -f -- "$lockDir/auth.json" "$lockDir/revision"; rmdir -- "$lockDir"' EXIT

          if authIsCurrent; then
            exit 0
          fi

          install -m 0600 -- "$sourceFile" "$lockDir/auth.json"
          printf '%s\n' "$revision" > "$lockDir/revision"
          mv -fT -- "$lockDir/auth.json" "$destination"
          mv -fT -- "$lockDir/revision" "$revisionFile"
        '';

        piPython = pkgs.python3.withPackages (ps: [
          ps.matplotlib
          ps.pexpect
          ps.plumbum
          ps.polars
          ps.pyelftools
          ps.requests
        ]);
      in
      {
        imports = [ inputs.pi-config.homeModules.default ];
        my.pi.package = pkgs.llm-agents.pi;

        sops.secrets.${authSecret} = lib.mkIf config.my.pi.enable {
          sopsFile = authFile;
          format = "binary";
        };
        systemd.user.services.sops-nix.Service.ExecStartPost = lib.mkIf (
          config.my.pi.enable && pkgs.stdenv.hostPlatform.isLinux
        ) "${deployAuth}";
        home.activation.deployPiAuth = lib.mkIf (config.my.pi.enable && pkgs.stdenv.hostPlatform.isDarwin) (
          lib.hm.dag.entryAfter [ "sops-nix" ] ''
            run ${deployAuth}
          ''
        );

        # MCP 服务表（含 org-wiki 记忆服务）由 pi-config 的 my.pi.mcp 生成。

        # interpreter + tool prompt for the pi-agent-extensions python tool
        xdg.configFile."pi-agent-extensions/python/config.json" = {
          # replaces the hand-written file from before this was managed here
          force = true;
          text = builtins.toJSON {
            python = "${piPython}/bin/python3";
            prompt = "Available besides stdlib: polars, matplotlib, requests, plumbum, pexpect, pyelftools. Drive interactive programs (ssh, REPLs, debuggers) with pexpect: child = pexpect.spawn(cmd, encoding='utf-8') persists across calls, always pass timeout= to expect().";
          };
        };
        home.packages = with pkgs; [
          # ACP (Agent Client Protocol) 适配器: ACP client <-> `pi --mode rpc`
          llm-agents.pi-acp
          nodejs
        ];
      };
  };
}
