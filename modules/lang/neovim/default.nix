{ inputs, ... }:
{
  flake-file.inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs-stable.follows = "nixpkgs-stable";
        nixpkgs.follows = "nixpkgs";
      };

    };
  };

  flake.modules.homeManager.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];
      stylix.targets.nixvim.enable = true;
      programs.nixvim = {
        enable = true;
        opts = {
          # Show line numbers
          number = true;

          # Show relative line numbers
          relativenumber = true;

          # Use the system clipboard
          clipboard = "unnamedplus";

          # Number of spaces that represent a <TAB>
          tabstop = 2;
          softtabstop = 2;

          # Show tabline always
          showtabline = 2;

          # Use spaces instead of tabs
          expandtab = true;

          # Enable smart indentation
          smartindent = true;

          # Number of spaces to use for each step of (auto)indent
          shiftwidth = 2;

          # Enable break indent
          breakindent = true;

          # Highlight the screen line of the cursor
          cursorline = true;

          # Minimum number of screen lines to keep above and below the cursor
          scrolloff = 8;

          # Enable mouse support
          mouse = "a";

          # Set folding method to manual
          foldmethod = "manual";

          # Disable folding by default
          foldenable = false;

          # Wrap long lines at a character in 'breakat'
          linebreak = true;

          # Disable spell checking
          spell = false;

          # Disable swap file creation
          swapfile = false;

          # Time in milliseconds to wait for a mapped sequence to complete
          timeoutlen = 300;

          # Enable 24-bit RGB color in the TUI
          termguicolors = true;

          # Don't show mode in the command line
          showmode = false;

          # Open new split below the current window
          splitbelow = true;

          # Keep the screen when splitting
          splitkeep = "screen";

          # Open new split to the right of the current window
          splitright = true;

          # Hide command line unless needed
          cmdheight = 0;

          # Remove EOB
          fillchars = {
            eob = " ";
          };
        };
        plugins.treesitter = {
          enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            # Linux
            bash
            ssh_config
            # sway
            tmux

            # Nix, Nixvim
            nix
            # query # treesitter queries
            vim
            vimdoc
            lua
            # luadoc

            # General Development
            csv
            diff
            editorconfig
            git_config
            git_rebase
            gitattributes
            gitcommit
            gitignore
            ini
            # llvm
            markdown
            markdown_inline
            regex
            # xml
            yaml

            # Rust Development
            # rust
            toml # Also for ZMK `keymap.toml`

            # Web Development
            css
            html
            # http
            # javascript
            json
            json5
            # php
            # php_only
            # phpdoc
            # sql
            # scss
            # twig
            # tsx
            # typescript

            # Web - other
            # astro
            # nginx
            # svelte
          ];
          settings = {
            highlight = {
              enable = true;
            };
            indent = {
              enable = true;
            };
          };
        };
      };
    };
}
