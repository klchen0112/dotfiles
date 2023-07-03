#
# Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# This is an ideal way to install on a vanilla NixOS installion.
# You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./vscode
{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions;
      [
        #themes
        mechatroner.rainbow-csv
        gruntfuggly.todo-tree
        johnpapa.vscode-peacock
        github.github-vscode-theme
        # akamud.vscode-theme-onelight
        # vscode-icons-team.vscode-icons

        # editor
        streetsidesoftware.code-spell-checker
        christian-kohler.path-intellisense
        tuttieee.emacs-mcx

        # ssh
        ms-vscode-remote.remote-ssh

        # git
        eamodio.gitlens
        donjayamanne.githistory
        mhutchie.git-graph
        # waderyan.gitblame
        # shell
        skyapps.fish-vscode
        # markdown
        yzhang.markdown-all-in-one

        # python
        ms-python.python
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-slideshow
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
        ms-python.vscode-pylance
        # ms-pyright.pyright
        # ms-pyright.pyright
        # cpp

        # nix
        bbenoist.nix
        # kamadorueda.alejandra
        jnoortheen.nix-ide
        # csv
        mechatroner.rainbow-csv
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "python-environment-manager";
          publisher = "donjayamanne";
          version = "1.0.4";
          sha256 = "E7pbzPFKmHIOQzETjNkcrNbI2mwhpxHPpGBIk/iflpo=";
        }
        {
          name = "vscode-theme-onelight";
          publisher = "akamud";
          version = "2.3.0";
          sha256 = "CTD0s2lRMCi/WCGr6dP1Utrvtsdcbg4srRcrZJSFDqU=";
        }
        # {
        #   name = "vscode-micromamba";
        #   publisher = "corker";
        #   version = "0.1.15";
        #   sha256 = "7m35bnGrgOt3uyRwSu93FCLYxeRiA6y97E8ypoi4Ouo=";
        # }
        {
          name = "theme-dracula";
          publisher = "dracula-theme";
          version = "2.24.2";
          sha256 = "YNqWEIvlEI29mfPxOQVdd4db9G2qNodhz8B0MCAAWK8=";
        }
        {
          name = "vsc-python-indent";
          publisher = "KevinRose";
          version = "1.18.0";
          sha256 = "hiOMcHiW8KFmau7WYli0pFszBBkb6HphZsz+QT5vHv0=";
        }
        {
          name = "cpptools";
          publisher = "ms-vscode";
          version = "1.15.4";
          sha256 = "+EfEeta+qAnX/xmcGP0sa6U0+VhToiqdHEXQDENxyGA=";
        }
        {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.13.0";
          sha256 = "8FUVGnUohSCpBUc+4h8yJIH+ICOOhzfuEpGsp7t2Xh0=";
        }

      ] ++ (lib.optionals pkgs.stdenv.isDarwin
        pkgs.vscode-utils.extensionsFromVscodeMarketplace
        [{
          name = "vscode-dash";
          publisher = "deerawan";
          version = "2.4.0";
          sha256 = "Yqn59ppNWQRMWGYVLLWofogds+4t/WRRtSSfomPWQy4=";
        }]
      )
    ;
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
      "[Log]" = {
        "editor.fontSize" = 13;
      };
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
      "editor.codeLensFontFamily" = "'Iosevka','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif'";
      "editor.fontFamily" = "'Iosevka','Overpass','CMU Typewriter Text','Noto Serif CJK SC','Noto Serif'";
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
      "search.exclude" = { };
      "search.showLineNumbers" = true;
      "search.smartCase" = true;
      "terminal.integrated.defaultProfile.windows" = "PowerShell";
      "terminal.external.osxExec" = "kitty.app";
      "terminal.integrated.automationProfile.osx" = "fish";
      "terminal.integrated.enableBell" = true;
      "terminal.integrated.env.windows" = {
        "LC_ALL" = "zh_CN.UTF-8";
      };
      "terminal.integrated.fontSize" = 15;
      "terminal.integrated.gpuAcceleration" = "on";
      "terminal.integrated.rightClickBehavior" = "selectWord";
      "todo-tree.general.tags" = [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "XXX"
        "[ ]"
        "[x]"
      ];
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
      # "window.autoDetectColorScheme" = true;
      # "workbench.preferredLightColorTheme" = "Atom One Light";
      # "workbench.preferredDarkColorTheme" = "Dracula";
      "workbench.colorTheme" = "Atom One Light";

      "remote.SSH.remotePlatform" = {
        "ningbo203" = "linux";
        "ningbo204" = "linux";
        "cy" = "linux";
        "i12500" = "linux";
      };
      "[yaml]" = {
        "editor.comments.insertSpace" = false;
      };
      "[python]" = {
        "editor.formatOnType" = true;
      };
    };
  };
}
