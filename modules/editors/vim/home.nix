{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs = {
    vim = {
      enable = false;
      settings = {
        background = "light";
        copyindent = true;
        number = true;
        relativenumber = true;
        shiftwidth = 4;
      };
      extraConfig = "
        set guifont=Courier:h12
        set foldenable      \" 允许折叠
        set showcmd         \"输入的命令显示出来，看的清楚些
        set shortmess=atI   \"启动的时候不显示那个援助乌干达儿童的提示
        set syntax=on \" 语法高亮
        set smartindent   \" 自动缩进
        set tabstop=4 \" Tab键的宽度
        set expandtab
        set autoindent
        set matchtime=1 \" 匹配括号高亮的时间（单位是十分之一秒）
        set nocompatible \"去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
        set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 \"设置编码
        set termencoding=utf-8
        set encoding=utf-8
        set showmatch \" 括号匹配
        set mouse=a \" 鼠标
        set selection=exclusive
        set selectmode=mouse,key
        set cursorline \" 高亮当前行
        set cmdheight=2 \" 命令行显示2行
        set hlsearch \" 高亮所有的搜索目标
      ";
    };
    # codes from https://github.com/JMartJonesy/kickstart.nixvim
    nixvim = {
      enable = true;
      viAlias = false;
      vimAlias = false;
      # Color scheme.
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "macchiato";
      };
      # Highlight todo, notes, etc in comments
      # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
      plugins.todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };
      plugins.treesitter = {
        enable = true;

        # TODO: Don't think I need this as nixGrammars is true which should auto install these???
        settings = {
          ensureInstalled = [
            "bash"
            "c"
            "diff"
            "html"
            "lua"
            "luadoc"
            "markdown"
            "markdown_inline"
            "query"
            "vim"
            "vimdoc"
          ];

          highlight = {
            enable = true;

            # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            additional_vim_regex_highlighting = true;
          };

          indent = {
            enable = true;
            disable = [
              "ruby"
            ];
          };

          # There are additional nvim-treesitter modules that you can use to interact
          # with nvim-treesitter. You should go explore a few and see what interests you:
          #
          #    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
          #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
          #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
        };
      };
      plugins.nvim-autopairs = {
        enable = true;
      };

      # If you want to automatically add `(` after selecting a function or method
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
      extraConfigLua = ''
        require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
      '';
      # Options.
      opts = {
        # Show line numbers
        number = true;
        # You can also add relative line numbers, to help with jumping.
        #  Experiment for yourself to see if you like it!
        #relativenumber = true

        # Enable mouse mode, can be useful for resizing splits for example!
        mouse = "a";

        # Don't show the mode, since it's already in the statusline
        showmode = false;

        # Enable break indent
        breakindent = true;

        # Save undo history
        undofile = true;

        # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
        ignorecase = true;
        smartcase = true;

        # Keep signcolumn on by default
        signcolumn = "yes";

        # Decrease update time
        updatetime = 250;

        # Decrease mapped sequence wait time
        # Displays which-key popup sooner
        timeoutlen = 300;

        # Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        # Sets how neovim will display certain whitespace characters in the editor
        #  See `:help 'list'`
        #  and `:help 'listchars'`
        list = true;
        # NOTE: .__raw here means that this field is raw lua code
        listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

        # Preview substitutions live, as you type!
        inccommand = "split";

        # Show which line your cursor is on
        cursorline = true;

        # Minimal number of screen lines to keep above and below the cursor.
        scrolloff = 10;

        # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
        # instead raise a dialog asking if you wish to save the current file(s)
        # See `:help 'confirm'`
        confirm = true;

        # See `:help hlsearch`
        hlsearch = true;
      };

      # Clipboard.
      clipboard = {
        providers.wl-copy.enable = true;
        # Sync clipboard between OS and Neovim
        #  Remove this option if you want your OS clipboard to remain independent.
        register = "unnamedplus";
      };
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
      globals = {
        # Set <space> as the leader key
        # See `:help mapleader`
        mapleader = " ";
        maplocalleader = " ";

        # Set to true if you have a Nerd Font installed and selected in the terminal
        have_nerd_font = true;
      };
    };
  };
}
