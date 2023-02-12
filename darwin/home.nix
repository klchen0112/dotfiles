#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  home = {                                        # Specific packages for macbook
    # packages = with pkgs; [
    #   # Terminal
    #   pfetch
    # ];
    stateVersion = "22.11";
  };

  programs = {
    zsh = {                                       # Post installation script is run in configuration.nix to make it default shell
      enable = true;
      enableAutosuggestions = true;               # Auto suggest options and highlights syntax. It searches in history for options
      enableSyntaxHighlighting = true;
      history.size = 10000;
      # This must be envExtra (rather than initExtra), because doom-emacs requires it
      # https://github.com/doomemacs/doomemacs/issues/687#issuecomment-409889275
      #
      envExtra = ''
          export PATH=/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin/:$PATH
          # For 1Password CLI. This requires `pkgs.gh` to be installed.
          source $HOME/.config/op/plugins.sh
          # Because, adding it in .ssh/config is not enough.
          # cf. https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
          # export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        '';
    };
    
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      # plugins = with pkgs.vimPlugins; [

      #   # Syntax
      #   vim-nix
      #   vim-markdown

      #   # Quality of life
      #   vim-lastplace                             # Opens document where you left it
      #   auto-pairs                                # Print double quotes/brackets/etc.
      #   vim-gitgutter                             # See uncommitted changes of file :GitGutterEnable

      #   # File Tree
      #   nerdtree                                  # File Manager - set in extraConfig to F6

      #   # Customization
      #   wombat256-vim                             # Color scheme for lightline
      #   srcery-vim                                # Color scheme for text

      #   lightline-vim                             # Info bar at bottom
      #   indent-blankline-nvim                     # Indentation lines
      # ];

      # extraConfig = ''
      #   syntax enable                             " Syntax highlighting
      #   colorscheme srcery                        " Color scheme text

      #   let g:lightline = {
      #     \ 'colorscheme': 'wombat',
      #     \ }                                     " Color scheme lightline

      #   highlight Comment cterm=italic gui=italic " Comments become italic
      #   hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

      #   set number                                " Set numbers

      #   nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
      # '';
    };
  };
}
