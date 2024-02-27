{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  programs.vscode = {
    enable = true;

    package = pkgs.unstable.vscode;

    extensions = with pkgs.vscode-marketplace;
      [
        #themes
        mechatroner.rainbow-csv
        gruntfuggly.todo-tree
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        # johnpapa.vscode-peacock
        # github.github-vscode-theme
        # akamud.vscode-theme-onelight
        # vscode-icons-team.vscode-icons

        # editor
        streetsidesoftware.code-spell-checker
        christian-kohler.path-intellisense
        # tuttieee.emacs-mcx
        vscodevim.vim
        wakatime.vscode-wakatime

        # ssh
        ms-vscode-remote.remote-ssh

        # git
        eamodio.gitlens
        #donjayamanne.githistory
        #mhutchie.git-graph
        # waderyan.gitblame

        # shell
        skyapps.fish-vscode
        # markdown
        yzhang.markdown-all-in-one

        # python
        ms-python.python
        ms-python.isort
        ms-pyright.pyright
        donjayamanne.python-environment-manager
        # ms-python.vscode-pylance
        # ms-toolsai.jupyter
        # ms-toolsai.vscode-jupyter-slideshow
        # ms-toolsai.vscode-jupyter-cell-tags
        # ms-toolsai.jupyter-renderers
        # ms-toolsai.jupyter-keymap
        # ms-pyright.pyright
        # cpp
        # llvm-vs-code-extensions.vscode-clangd
        # ms-vscode.cmake-tools
        # ms-vscode.cpptools

        # nix
        bbenoist.nix
        kamadorueda.alejandra
        jnoortheen.nix-ide
        # csv

        # copilot
        github.copilot
        github.copilot-chat

        james-yu.latex-workshop
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin
      (with pkgs.vscode-marketplace; [
        deerawan.vscode-dash
      ]);
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "settingsSync.keybindingsPerPlatform" = true;
      "update.mode" = "none";
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "C_Cpp.errorSquiggles" = "Enabled";
      "C_Cpp.intelliSenseEngine" = "Disabled";
      "C_Cpp.intelliSenseEngineFallback" = "Disabled";
      "[Log]" = {"editor.fontSize" = 13;};
      "[c]" = {
        "editor" = {
          "quickSuggestions" = {
            "comments" = "on";
            "strings" = "on";
            "other" = "on";
          };
          "defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };
      };
      "[cpp]" = {
        "editor.quickSuggestions" = {
          "comments" = "on";
          "strings" = "on";
          "other" = "on";
        };
      };
      "editor.quickSuggestions" = {
        "comments" = true;
        "other" = true;
        "strings" = true;
      };
      "files.autoSave" = "afterDelay";
      "editor.codeLensFontFamily" = "'Jetbrains Mono','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif','Hack Nerd Font'";
      "editor.fontFamily" = "'Jetbrains Mono','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif','Hack Nerd Font'";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "editor.quickSuggestionsDelay" = 0;
      "editor.renderWhitespace" = "none";
      "editor.snippetSuggestions" = "top";
      "editor.stickyTabStops" = true;
      "editor.suggest.localityBonus" = true;
      "editor.suggest.shareSuggestSelections" = true;
      "editor.suggest.snippetsPreventQuickSuggestions" = false;
      "editor.suggestOnTriggerCharacters" = true;
      "editor.suggestSelection" = "first";
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.wordWrap" = "on";

      "clangd.arguments" = [
        "--log=verbose"
        "--pretty"
        "--all-scopes-completion"
        "--completion-style=bundled"
        "--header-insertion=iwyu"
        "--cross-file-rename"
        "--header-insertion-decorators"
        "--background-index"
        "--clang-tidy"
        "--clang-tidy-checks=cppcoreguidelines-*;performance-*;bugprone-*;portability-*;modernize-*;google-*"
        "--fallback-style=file"
        "-j=8"
        "--pch-storage=memory"
        "--function-arg-placeholders=false"
        "--compile-commands-dir=build"
      ];
      "editor.tabCompletion" = "off";
      "clangd.detectExtensionConflicts" = false;
      "clangd.onConfigChanged" = "restart";
      "cmake.configureOnOpen" = false;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.incrementalNaming" = "smart";
      "extensions.ignoreRecommendations" = true;
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.factorypath" = true;
        "**/.project" = true;
        "**/.settings" = true;
      };
      "git.autofetch" = true;
      "json.maxItemsComputed" = 10000;
      "security.workspace.trust.untrustedFiles" = "open";
      "search.exclude" = {};
      "search.showLineNumbers" = true;
      "search.smartCase" = true;
      "terminal.integrated.defaultProfile.windows" = "PowerShell";
      "terminal.external.osxExec" = "kitty.app";
      "terminal.integrated.automationProfile.osx" = "fish";
      "terminal.integrated.enableBell" = true;
      "terminal.integrated.env.windows" = {"LC_ALL" = "zh_CN.UTF-8";};
      "terminal.integrated.fontSize" = 15;
      "terminal.integrated.gpuAcceleration" = "on";
      "terminal.integrated.rightClickBehavior" = "selectWord";
      "terminal.integrated.minimumContrastRatio" = 1;
      "todo-tree.general.tags" = ["BUG" "HACK" "FIXME" "TODO" "XXX" "[ ]" "[x]"];
      "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)";
      "workbench.editor.enablePreview" = false;
      "terminal.explorerKind" = "external";
      "editor.lineNumbers" = "relative";
      "terminal.integrated.copyOnSelection" = true;
      "gitlens.advanced.messages" = {
        "suppressCreatePullRequestPrompt" = true;
      };
      "editor.formatOnType" = true;
      "C_Cpp.clang_format_fallbackStyle" = "file";
      "GitCommitPlugin.ShowEmoji" = true;
      "C_Cpp.autocompleteAddParentheses" = true;
      "cmake.autoSelectActiveFolder" = false;
      "cmake.cmakeCommunicationMode" = "legacy";
      "editor.inlineSuggest.enabled" = true;
      "githubPullRequests.createOnPublishBranch" = "never";
      "C_Cpp.inactiveRegionOpacity" = 0.55;
      "editor.guides.indentation" = true;
      "editor.unicodeHighlight.ambiguousCharacters" = false;
      "editor.unicodeHighlight.nonBasicASCII" = false;
      "remote.SSH.useLocalServer" = false;
      # we try to make semantic highlighting look good
      "editor.semanticHighlighting.enabled" = true;

      "window.titleBarStyle" = "custom";
      # "window.autoDetectColorScheme" = true;
      # "workbench.preferredLightColorTheme" = "Catppuccin Latte";
      # "workbench.preferredDarkColorTheme" = "Catppuccin Macchiato";
      "workbench.colorTheme" = "Catppuccin Latte";
      "workbench.iconTheme" = "Catppuccin Latte";

      "remote.SSH.remotePlatform" = {
        "ningbo40" = "linux";
        "ningbo203" = "linux";
        "ningbo204" = "linux";
        "cy" = "linux";
        "i12500" = "linux";
      };
      "[yaml]" = {"editor.comments.insertSpace" = false;};
      "[python]" = {"editor.formatOnType" = true;};
    };
  };
}
