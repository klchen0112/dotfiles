{
  flake-file.inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  flake.modules.homeManager.vscode =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = with pkgs; [
        nerd-fonts.hack
        cm_unicode
        noto-fonts-cjk-sans
        overpass
      ];
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false; # Whether extensions can be installed or updated manually or by Visual Studio Code.

        profiles.default.extensions =

          with pkgs.vscode-extensions;
          [
            tuttieee.emacs-mcx
            # ssh
            ms-vscode-remote.remote-ssh
            # copilot
            # github.copilot
            # github.copilot-chat
            # python
            ms-python.python
            ms-pyright.pyright
            charliermarsh.ruff

            ms-toolsai.jupyter
            ms-toolsai.vscode-jupyter-slideshow
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.jupyter-renderers
            ms-toolsai.jupyter-keymap

          ]
          ++ (with pkgs.vscode-marketplace; [
            spadin.zmk-tools
            #themes
            mechatroner.rainbow-csv
            gruntfuggly.todo-tree
            vscode-icons-team.vscode-icons
            # johnpapa.vscode-peacock
            # github.github-vscode-theme
            # akamud.vscode-theme-onelight

            # editor
            streetsidesoftware.code-spell-checker
            christian-kohler.path-intellisense
            # tuttieee.emacs-mcx
            # vscodevim.vim
            # wakatime.vscode-wakatime
            oderwat.indent-rainbow
            njqdev.vscode-python-typehint
            # docstring
            njpwerner.autodocstring

            # python
            donjayamanne.python-environment-manager
            cstrap.python-snippets
            tamasfe.even-better-toml
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
            # comment
            # corker.vscode-micromamba
            # cpp
            # llvm-vs-code-extensions.vscode-clangd
            # ms-vscode.cmake-tools
            # ms-vscode.cpptools
            # nix
            bbenoist.nix
            jnoortheen.nix-ide

            # csv

            # james-yu.latex-workshop
            # keyboard
            # spadin.zmk-tools
          ]);
        profiles.default.enableUpdateCheck = false;
        profiles.default.enableExtensionUpdateCheck = false;
        profiles.default.userSettings =
          let
            fontFamily = "'M+CodeLat50 Nerd Font','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif','Symbols Nerd Font Mono','Hack Nerd Font'";
          in
          {
            "update.mode" = "none";
            "extensions.autoCheckUpdates" = false;
            "extensions.autoUpdate" = false;
            "extensions.ignoreRecommendations" = true;
            "C_Cpp" = {
              "errorSquiggles" = "Enabled";
              "intelliSenseEngine" = "Disabled";
              "intelliSenseEngineFallback" = "Disabled";
              "clang_format_fallbackStyle" = "file";
              "autocompleteAddParentheses" = true;
              "inactiveRegionOpacity" = 0.55;
            };
            # --------------------------------------------
            # Editor Settings
            # --------------------------------------------
            "editor.quickSuggestions" = {
              "comments" = true;
              "other" = true;
              "strings" = true;
            };

            "editor.inlineSuggest.enabled" = true;
            "editor.semanticHighlighting.enabled" = true;
            "editor.fontFamily" = fontFamily;
            "editor.codeLensFontFamily" = fontFamily;
            "editor.fontLigatures" = true;
            "editor.formatOnPaste" = false;
            "editor.formatOnType" = false;
            "editor.formatOnSave" = false;
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
            "editor.wordWrap" = "off";
            "editor.tabCompletion" = "off";
            "editor.guides.indentation" = true;
            "editor.unicodeHighlight.ambiguousCharacters" = false;
            "editor.unicodeHighlight.nonBasicASCII" = false;
            "editor.lineNumbers" = "relative";
            # --------------------------------------------
            # Explorer Settings
            # --------------------------------------------
            "explorer.confirmDelete" = false;
            "explorer.confirmDragAndDrop" = false;
            "explorer.incrementalNaming" = "smart";
            # --------------------------------------------
            # File Settings
            # --------------------------------------------
            "files.autoSave" = "afterDelay";
            "files.insertFinalNewline" = true;
            "files.trimTrailingWhitespace" = true;
            "files.exclude" = {
              "**/.classpath" = true;
              "**/.factorypath" = true;
              "**/.project" = true;
              "**/.settings" = true;
            };

            "json.maxItemsComputed" = 10000;
            "security.workspace.trust.untrustedFiles" = "open";

            # --------------------------------------------
            # Search Settings
            # --------------------------------------------
            "search.exclude" = { };
            "search.showLineNumbers" = true;
            "search.smartCase" = true;

            # --------------------------------------------
            # Terminal Settings
            # --------------------------------------------
            "terminal.integrated.fontFamily" = fontFamily;
            "terminal.integrated.defaultProfile.windows" = "PowerShell";
            "terminal.integrated.defaultProfile.osx" = "nushell";
            "terminal.integrated.defaultProfile.linux" = "nushell";
            "terminal.integrated.profiles.osx" = {
              "bash" = {
                "path" = "/etc/profiles/per-user/${config.home.username}//bin/bash";
                "args" = [
                  "-l"
                ];
                "icon" = "terminal-bash";
              };
              "zsh" = {
                "path" = "/etc/profiles/per-user/${config.home.username}/bin/zsh";
                "args" = [
                  "-l"
                ];
              };
              "fish" = {
                "path" = "/etc/profiles/per-user/${config.home.username
                }/bin/fish";
                "args" = [
                  "-l"
                ];
              };
              "nushell" = {
                "path" = "/etc/profiles/per-user/${config.home.username}/bin/nu";
              };
            };
            "terminal.integrated.profiles.linux" = {
              "bash" = {
                "path" = "/etc/profiles/per-user/${config.home.username}/bin/bash";
                "args" = [
                  "-l"
                ];
                "icon" = "terminal-bash";
              };
              "zsh" = {
                "path" = "/etc/profiles/per-user/${config.home.username}/bin/zsh";
                "args" = [
                  "-l"
                ];
              };
              "fish" = {
                "path" = "/etc/profiles/per-user/${config.home.username}/bin/fish";
                "args" = [
                  "-l"
                ];
              };
              "nushell" = {
                "path" = "/etc/profiles/per-user/${config.home.username}/bin/nu";
              };
            };
            "terminal.integrated.enableVisualBell" = true;
            "terminal.integrated.gpuAcceleration" = "on";
            "terminal.integrated.env.windows" = {
              "LC_ALL" = "zh_CN.UTF-8";
            };
            "terminal.integrated.rightClickBehavior" = "selectWord";
            "terminal.integrated.minimumContrastRatio" = 1;
            "terminal.integrated.copyOnSelection" = true;
            "terminal.external.osxExec" = "kitty.app";
            "terminal.explorerKind" = "external";
            "accessibility.signals.terminalBell" = {
              "sound" = "on";
            };
            # --------------------------------------------
            # Todo Settings
            # --------------------------------------------
            "todo-tree" = {
              "general.tags" = [
                "BUG"
                "HACK"
                "FIXME"
                "TODO"
                "XXX"
                "[ ]"
                "[x]"
              ];
              "regex.regex" = "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)";
            };

            # Git Settings
            "git.autofetch" = true;
            "gitlens.advanced.messages" = {
              "suppressCreatePullRequestPrompt" = true;
            };
            "GitCommitPlugin.ShowEmoji" = true;
            "githubPullRequests.createOnPublishBranch" = "never";

            # --------------------------------------------
            # Window settings
            # --------------------------------------------
            "window.titleBarStyle" = "custom";
            # "window.autoDetectColorScheme" = true;
            # "workbench.preferredLightColorTheme" = "Catppuccin Latte";
            # "workbench.preferredDarkColorTheme" = "Catppuccin Macchiato";
            # "workbench.iconTheme" = "catppuccin-latte";
            # "workbench.productIconTheme"= "vscode-icons";
            "workbench.iconTheme" = "vscode-icons";
            "workbench.editor.enablePreview" = false;

            # --------------------------------------------
            # Remote SSH
            # --------------------------------------------
            "remote.SSH.useLocalServer" = false;
            "remote.SSH.remotePlatform" = {
              "ningbo40" = "linux";
              "ningbo203" = "linux";
              "ningbo204" = "linux";
              "cy" = "linux";
              "i12r20" = "linux";
              "a3400g" = "linux";
              "sanjiao" = "linux";
              "a99r50" = "linux";
            };
            "remote.SSH.localServerDownload" = false;

            # --------------------------------------------
            # --------------------------------------------
            # Language settings
            # --------------------------------------------
            # --------------------------------------------
            "[yaml]" = {
              "editor.comments.insertSpace" = false;
            };
            "[python]" = {
              "editor.formatOnType" = false;
            };

            # --------------------------------------------
            # C/C++ settings
            # --------------------------------------------
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
            "[c]" = {
              "editor.quickSuggestions.comments" = "on";
              "editor.quickSuggestions.strings" = "on";
              "editor.quickSuggestions.other" = "on";
              # "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
            };
            "[cpp]" = {
              "editor.quickSuggestion.comments" = "on";
              "editor.quickSuggestion.strings" = "on";
              "editor.quickSuggestion.other" = "on";
            };
            "cmake.autoSelectActiveFolder" = false;
            "cmake.cmakeCommunicationMode" = "legacy";
            "cmake.configureOnOpen" = false;
            "[Log]" = {
              "editor.fontSize" = 13;
            };

            # Nix

            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";

            "workbench.editorAssociations" = {
              "*.md" = "milkdown.editor";
            };
          };
      };
    };
}
