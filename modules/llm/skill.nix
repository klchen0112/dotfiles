{ inputs, ... }:
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
            path = inputs.wondelai-skills.outPath;
            idPrefix = "wondelai";
            subdir = ".";
            filter.maxDepth = 1; # top-level directories are skills; skip .claude/.cursor etc.
          };

          # tlehman/litprog-skill — literate programming skill
          litprog = {
            path = inputs.litprog-skill.outPath;
            subdir = ".";
            idPrefix = "litprog";
          };
          mattpocock-skills = {
            path = inputs.mattpocock-skills.outPath;
            subdir = "skills";
            idPrefix = "mattpocock";
            filter.maxDepth = 3;
          };
          # sudosubin/nix-skills — 480,000+ skills from skills.sh/skillsdirectory.com (individual packages)
          #          nix-skills = {
          #            path = inputs.nix-skills.outPath;
          #            subdir = "skills";
          #            filter.maxDepth = 1;
          #          };

          # ZeroPointRepo/youtube-skills — YouTube transcript/search skills
          youtube = {
            path = inputs.youtube-skills.outPath;
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
