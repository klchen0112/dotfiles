{
    "update.mode" = "none";
    "C_Cpp.errorSquiggles" = "Enabled";
    "C_Cpp.intelliSenseEngine" = "Disabled";
    "C_Cpp.intelliSenseEngineFallback" = "Disabled";
    "[Log]" = {
        "editor.fontSize" = 13;
    };
    "[c]" = {
        "editor" = {
            quickSuggestions" = {
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
        }
    };
    "editor.quickSuggestions" = {
        "comments" = true;
        "other" = true;
        "strings" = true;
    };
    "editor.codeLensFontFamily" = "'SF Mono';'CMU Typewriter Text';'Sarasa Mono SC'";
    "editor.fontFamily" = "'SF Mono';'Sarasa Mono SC'";
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
    "clangd.arguments" = [
        "--log=verbose";
        "--pretty";
        "--all-scopes-completion";
        "--completion-style=bundled";
        "--header-insertion=iwyu";
        "--cross-file-rename";
        "--header-insertion-decorators";
        "--background-index";
        "--clang-tidy";
        "--clang-tidy-checks=cppcoreguidelines-*;performance-*;bugprone-*;portability-*;modernize-*;google-*";
        "--fallback-style=file";
        "-j=8";
        "--pch-storage=memory";
        "--function-arg-placeholders=false";
        "--compile-commands-dir=build";
    ];
    "clangd.detectExtensionConflicts" = false;
    "clangd.onConfigChanged" = "restart";
    "cmake.configureOnOpen" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.incrementalNaming" = "smart";
    "extensions.ignoreRecommendations" = true;
    "files.autoSave" = "afterDelay";
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
    "terminal.integrated.enableBell" = true;
    "terminal.integrated.env.windows" = {
        "LC_ALL" = "zh_CN.UTF-8";
    };
    "terminal.integrated.fontSize" = 15;
    "terminal.integrated.gpuAcceleration" = "on";
    "terminal.integrated.rightClickBehavior" = "selectWord";
    "todo-tree.general.tags" = [
        "BUG";
        "HACK";
        "FIXME";
        "TODO";
        "XXX";
        "[ ]";
        "[x]";
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
    "workbench.colorTheme" = "Atom One Light";
    "update.mode" = "none";
}