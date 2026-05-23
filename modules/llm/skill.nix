{
  den,
  inputs,
  lib,
  ...
}:
{
  # Declarative agent skill management via agent-skills-nix.
  # Syncs SKILL.md directories from pinned flake sources to $HOME/.agents/skills.

  flake-file.inputs = {
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    wondelai-skills = {
      url = "github:wondelai/skills";
      flake = false;
    };

    litprog-skill = {
      url = "github:tlehman/litprog-skill";
      flake = false;
    };
    youtube-skills = {
      url = "github:ZeroPointRepo/youtube-skills";
      flake = false;
    };
  };

  # Pass flake inputs to home-manager so agent-skills-nix can resolve source
  # `input` references (e.g. "wondelai-skills" -> inputs.wondelai-skills).
  den.aspects.skill.nixos =
    { lib, config, ... }:
    {
      home-manager.extraSpecialArgs.inputs = inputs;
    };

  den.aspects.skill.homeManager =
    { pkgs, config, ... }:
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
            subdir = ".";
            filter.maxDepth = 1; # top-level directories are skills; skip .claude/.cursor etc.
          };

          # tlehman/litprog-skill — literate programming skill
          litprog = {
            input = "litprog-skill";
            subdir = ".";
          };

          # ZeroPointRepo/youtube-skills — YouTube transcript/search skills
          youtube = {
            input = "youtube-skills";
            subdir = "skills";
            filter.maxDepth = 1;
          };
        };

        skills.enableAll = true;

        # Sync to $HOME/.agents/skills for use by Claude Code, OpenCode, Hermes, etc.
        targets.agents.enable = true;
        targets.hermes = {
          enable = true;
          dest = "$HOME/.hermes/skills";
        };

      };

    };
}
