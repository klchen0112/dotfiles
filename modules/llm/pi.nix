{ den, inputs, ... }:
{
  flake-file.inputs = {
    pi = {
      url = "github:earendil-works/pi/stable";
      # url = "git+file:///home/klchen/my/hermes-agent";
      # url = "github:klchen0112/hermes-agent/own";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.pi = {
    pi =
      {
        pkgs,
        lib,
        config,
        inputs,
        ...
      }:
      let
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
        # interpreter + tool prompt for the pi-agent-extensions python tool
        xdg.configFile."pi-agent-extensions/python/config.json" = {
          # replaces the hand-written file from before this was managed here
          force = true;
          text = builtins.toJSON {
            python = "${piPython}/bin/python3";
            prompt = "Available besides stdlib: polars, matplotlib, requests, plumbum, pexpect, pyelftools. Drive interactive programs (ssh, REPLs, debuggers) with pexpect: child = pexpect.spawn(cmd, encoding='utf-8') persists across calls, always pass timeout= to expect().";
          };
        };
        nixpkgs.overlays = [
          inputs.pi.overlays.default
        ];
        home.packages = with pkgs; [ pi ];
      };
  };
}
