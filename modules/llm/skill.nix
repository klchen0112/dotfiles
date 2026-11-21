{
  den,
  inputs,
  ...
}:
{
  # Declarative agent skill management via agent-skills-nix.
  # Syncs SKILL.md directories from pinned flake sources to $HOME/.agents/skills.

  flake-file.inputs = {
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wondelai-skills = {
      url = "github:wondelai/skills";
      flake = false;
    };

    litprog-skill = {
      url = "github:tlehman/litprog-skill";
      flake = false;
    };
    nix-skills = {
      url = "github:sudosubin/nix-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    youtube-skills = {
      url = "github:ZeroPointRepo/youtube-skills";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  # Pass flake inputs to home-manager so agent-skills-nix can resolve source
  # `input` references (e.g. "wondelai-skills" -> inputs.wondelai-skills).
  # `home-manager.extraSpecialArgs` 是 host 级 NixOS 选项（喂给该 host 上所有 HM
  # 模块）。这里用 `provides.to-hosts` 点名投递：只有“有用到 skill 的用户”的 host
  # 才拿到它，不假定所有 host 都如此。
  den.aspects.skill.provides.to-hosts.nixos.home-manager.extraSpecialArgs.inputs = inputs;

  den.aspects.skill.homeManager =
    { pkgs, ... }:
    {
      imports = [
        inputs.agent-skills-nix.homeManagerModules.default
      ];
      home.packages = with pkgs; [ bun ];
      programs.agent-skills = {
        enable = true;

        sources = {
          # wondelai/skills — 42 business/craft/design skills
          wondelai = {
            input = "wondelai-skills";
            idPrefix = "wondelai";
            subdir = ".";
            filter.maxDepth = 1; # top-level directories are skills; skip .claude/.cursor etc.
          };

          # tlehman/litprog-skill — literate programming skill
          litprog = {
            input = "litprog-skill";
            subdir = ".";
            idPrefix = "litprog";
          };
          mattpocock-skills = {
            input = "mattpocock-skills";
            subdir = "skills";
            idPrefix = "mattpocock";
            filter.maxDepth = 3;
          };
          # sudosubin/nix-skills — 480,000+ skills from skills.sh/skillsdirectory.com (individual packages)
          #          nix-skills = {
          #            input = "nix-skills";
          #            subdir = "skills";
          #            filter.maxDepth = 1;
          #          };

          # ZeroPointRepo/youtube-skills — YouTube transcript/search skills
          youtube = {
            input = "youtube-skills";
            subdir = "skills";
            idPrefix = "ZeroPointRepo";
            filter.maxDepth = 1;
          };

          # Lum1104/Understand-Anything — interactive codebase knowledge graphs
        };

        skills.enableAll = true;

        # Sync to $HOME/.agents/skills for use by Claude Code, OpenCode, Hermes, etc.
        targets.agents.enable = true;
        targets.pi.enable = true;
      };

    };
}
