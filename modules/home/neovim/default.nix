{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.nix4nvchad.homeManagerModule
  ];
  programs = {
    # codes from https://github.com/JMartJonesy/kickstart.nixvim
    # nixvim = {
    #   enable = true;
    #   viAlias = false;
    #   vimAlias = false;
    #   # Color scheme.
    #   colorschemes.catppuccin = {
    #     enable = true;
    #     settings.flavour = "macchiato";
    #   };
    #   # Highlight todo, notes, etc in comments
    #   # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    #   plugins.todo-comments = {
    #     enable = true;
    #     settings = {
    #       signs = true;
    #     };
    #   };
    #   plugins.treesitter = {
    #     enable = true;

    #     # TODO: Don't think I need this as nixGrammars is true which should auto install these???
    #     settings = {
    #       ensureInstalled = [
    #         "bash"
    #         "c"
    #         "diff"
    #         "html"
    #         "lua"
    #         "luadoc"
    #         "markdown"
    #         "markdown_inline"
    #         "query"
    #         "vim"
    #         "vimdoc"
    #       ];

    #       highlight = {
    #         enable = true;

    #         # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    #         additional_vim_regex_highlighting = true;
    #       };

    #       indent = {
    #         enable = true;
    #         disable = [
    #           "ruby"
    #         ];
    #       };

    #       # There are additional nvim-treesitter modules that you can use to interact
    #       # with nvim-treesitter. You should go explore a few and see what interests you:
    #       #
    #       #    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    #       #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
    #       #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
    #     };
    #   };
    #   plugins.nvim-autopairs = {
    #     enable = true;
    #   };

    #   # If you want to automatically add `(` after selecting a function or method
    #   # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
    #   # Options.
    #   opts = {
    #     # Show line numbers
    #     number = true;
    #     # You can also add relative line numbers, to help with jumping.
    #     #  Experiment for yourself to see if you like it!
    #     #relativenumber = true

    #     # Enable mouse mode, can be useful for resizing splits for example!
    #     mouse = "a";

    #     # Don't show the mode, since it's already in the statusline
    #     showmode = false;

    #     # Enable break indent
    #     breakindent = true;

    #     # Save undo history
    #     undofile = true;

    #     # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
    #     ignorecase = true;
    #     smartcase = true;

    #     # Keep signcolumn on by default
    #     signcolumn = "yes";

    #     # Decrease update time
    #     updatetime = 250;

    #     # Decrease mapped sequence wait time
    #     # Displays which-key popup sooner
    #     timeoutlen = 300;

    #     # Configure how new splits should be opened
    #     splitright = true;
    #     splitbelow = true;

    #     # Sets how neovim will display certain whitespace characters in the editor
    #     #  See `:help 'list'`
    #     #  and `:help 'listchars'`
    #     list = true;
    #     # NOTE: .__raw here means that this field is raw lua code
    #     listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    #     # Preview substitutions live, as you type!
    #     inccommand = "split";

    #     # Show which line your cursor is on
    #     cursorline = true;

    #     # Minimal number of screen lines to keep above and below the cursor.
    #     scrolloff = 10;

    #     # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
    #     # instead raise a dialog asking if you wish to save the current file(s)
    #     # See `:help 'confirm'`
    #     confirm = true;

    #     # See `:help hlsearch`
    #     hlsearch = true;
    #   };

    #   # Clipboard.
    #   clipboard = {
    #     providers.wl-copy.enable = true;
    #     # Sync clipboard between OS and Neovim
    #     #  Remove this option if you want your OS clipboard to remain independent.
    #     register = "unnamedplus";
    #   };
    #   # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
    #   globals = {
    #     # Set <space> as the leader key
    #     # See `:help mapleader`
    #     mapleader = " ";
    #     maplocalleader = " ";

    #     # Set to true if you have a Nerd Font installed and selected in the terminal
    #     have_nerd_font = true;
    #   };
    # };
    nvchad = {
      enable = true;
      extraPackages = with pkgs; [
        nodePackages.bash-language-server
        docker-compose-language-service
        dockerfile-language-server-nodejs
        emmet-language-server
        nixd
        (python3.withPackages (
          ps: with ps; [
            python-lsp-server
            flake8
          ]
        ))
      ];
      hm-activation = true;
      backup = true;
    };
  };
}
