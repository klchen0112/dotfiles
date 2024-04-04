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
    mutableExtensionsDir =
      false; # Whether extensions can be installed or updated manually or by Visual Studio Code.
    extensions = with pkgs.vscode-extensions;
      [
        # ssh
        ms-vscode-remote.remote-ssh
        # copilot
        github.copilot
        github.copilot-chat
      ]
      ++ (with pkgs.vscode-marketplace; [
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
        # vscodevim.vim
        wakatime.vscode-wakatime

        # git
        # eamodio.gitlens
        #donjayamanne.githistory
        #mhutchie.git-graph
        # waderyan.gitblame
        kahole.magit
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
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-slideshow
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
        # cpp
        # llvm-vs-code-extensions.vscode-clangd
        # ms-vscode.cmake-tools
        # ms-vscode.cpptools

        # nix
        bbenoist.nix
        kamadorueda.alejandra
        jnoortheen.nix-ide
        # csv

        james-yu.latex-workshop
      ])
      ++ lib.optionals pkgs.stdenv.isDarwin
      (with pkgs.vscode-marketplace; [deerawan.vscode-dash]);
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "settingsSync.keybindingsPerPlatform" = true;
      "update.mode" = "none";
      "extensions" = {
        "autoCheckUpdates" = false;
        "autoUpdate" = false;
        "ignoreRecommendations" = true;
      };
      "C_Cpp" = {
        "errorSquiggles" = "Enabled";
        "intelliSenseEngine" = "Disabled";
        "intelliSenseEngineFallback" = "Disabled";
        "clang_format_fallbackStyle" = "file";
        "autocompleteAddParentheses" = true;
        "inactiveRegionOpacity" = 0.55;
      };
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
      "cmake" = {
        "autoSelectActiveFolder" = false;
        "cmakeCommunicationMode" = "legacy";
        "configureOnOpen" = false;
      };
      "editor" = {
        "quickSuggestions" = {
          "comments" = true;
          "other" = true;
          "strings" = true;
        };
        "inlineSuggest.enabled" = true;
        "semanticHighlighting.enabled" = true;
        "codeLensFontFamily" = "'JetBrains Mono','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif','Hack Nerd Font'";
        "fontFamily" = "'JetBrains Mono','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif','Hack Nerd Font'";
        "fontLigatures" = true;
        "fontSize" = 16;
        "formatOnPaste" = true;
        "formatOnType" = true;
        "formatOnSave" = true;
        "minimap.enabled" = false;
        "quickSuggestionsDelay" = 0;
        "renderWhitespace" = "none";
        "snippetSuggestions" = "top";
        "stickyTabStops" = true;
        "suggest" = {
          "localityBonus" = true;
          "shareSuggestSelections" = true;
          "snippetsPreventQuickSuggestions" = false;
        };
        "suggestOnTriggerCharacters" = true;
        "suggestSelection" = "first";
        "bracketPairColorization.enabled" = true;
        "guides.bracketPairs" = "active";
        "wordWrap" = "off";
        "tabCompletion" = "off";
        "guides.indentation" = true;
        "unicodeHighlight.ambiguousCharacters" = false;
        "unicodeHighlight.nonBasicASCII" = false;
        "lineNumbers" = "relative";
      };
      "explorer" = {
        "confirmDelete" = false;
        "confirmDragAndDrop" = false;
        "incrementalNaming" = "smart";
      };
      "files" = {
        "autoSave" = "afterDelay";
        "insertFinalNewline" = true;
        "trimTrailingWhitespace" = true;
        "exclude" = {
          "**/.classpath" = true;
          "**/.factorypath" = true;
          "**/.project" = true;
          "**/.settings" = true;
        };
      };
      "clangd" = {
        "arguments" = [
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
        "detectExtensionConflicts" = true;
        "onConfigChanged" = "restart";
      };

      "json.maxItemsComputed" = 10000;
      "security.workspace.trust.untrustedFiles" = "open";
      "search" = {
        "exclude" = {};
        "showLineNumbers" = true;
        "smartCase" = true;
      };

      "terminal" = {
        "integrated" = {
          "fontFamily" = "'JetBrains Mono','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif','Hack Nerd Font'";
          "defaultProfile.windows" = "PowerShell";
          "automationProfile.osx" = "fish";
          "enableBell" = true;
          "env.windows" = {"LC_ALL" = "zh_CN.UTF-8";};
          "fontSize" = 15;
          "gpuAcceleration" = "on";
          "rightClickBehavior" = "selectWord";
          "minimumContrastRatio" = 1;
          "copyOnSelection" = true;
          "enableVisualBell" = true;
        };
        "external.osxExec" = "Alacritty.app";
        "explorerKind" = "external";
      };
      "todo-tree" = {
        "general.tags" = ["BUG" "HACK" "FIXME" "TODO" "XXX" "[ ]" "[x]"];
        "regex.regex" = "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)";
      };

      "git.autofetch" = true;
      "gitlens.advanced.messages" = {
        "suppressCreatePullRequestPrompt" = true;
      };
      "GitCommitPlugin.ShowEmoji" = true;
      "githubPullRequests.createOnPublishBranch" = "never";

      # we try to make semantic highlighting look good

      "window" = {
        "titleBarStyle" = "custom";
        # "autoDetectColorScheme" = true;
      };
      # "workbench.preferredLightColorTheme" = "Catppuccin Latte";
      # "workbench.preferredDarkColorTheme" = "Catppuccin Macchiato";
      "workbench" = {
        "colorTheme" = "Catppuccin Latte";
        "iconTheme" = "Catppuccin Latte";
        "editor.enablePreview" = false;
      };

      "remote.SSH" = {
        "SSH.useLocalServer" = false;
        "remotePlatform" = {
          "ningbo40" = "linux";
          "ningbo203" = "linux";
          "ningbo204" = "linux";
          "cy" = "linux";
          "i12500" = "linux";
        };
      };
      "remote.SSH.localServerDownload" = true;
      "remote.SSH.useLocalServer" = true;
      "[yaml]" = {"editor.comments.insertSpace" = false;};
      "[python]" = {"editor.formatOnType" = true;};
      "accessibility.signals.terminalBell" = {"sound" = "on";};
      "workbench.editor.enablePreview" = false;
      "terminal.integrated.enableVisualBell" = true;
    };
  };
}
