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
          # 66 个业务/设计/写作 skill（源仓库 README 写 42，实际 66 个顶层目录），成本只是磁盘体积，全部保留。
          wondelai = {
            path = inputs.wondelai-skills.outPath;
            idPrefix = "wondelai";
            subdir = ".";
            filter.maxDepth = 1; # top-level directories are skills; skip .claude/.cursor etc.
          };

          mattpocock-skills = {
            path = inputs.mattpocock-skills.outPath;
            subdir = "skills";
            idPrefix = "mattpocock";
            filter.maxDepth = 3;
          };
        };

        # wondelai 整源照单全收；mattpocock 只装实际用得到的（新增时在这里加 catalog id）。
        skills.enableAll = [ "wondelai" ];
        skills.enable = [
          "mattpocock/engineering/code-review"
          "mattpocock/engineering/codebase-design"
          "mattpocock/engineering/diagnosing-bugs"
          "mattpocock/engineering/domain-modeling"
          "mattpocock/engineering/pr"
          "mattpocock/engineering/prototype"
          "mattpocock/engineering/research"
          "mattpocock/engineering/tdd"
          "mattpocock/engineering/triage"
          "mattpocock/productivity/grilling"
          "mattpocock/productivity/writing-for-agents"
        ];

        # Sync to $HOME/.agents/skills for use by Claude Code, OpenCode, Hermes, etc.
        targets.agents.enable = true;
        targets.pi.enable = true;
      };

    };
}
