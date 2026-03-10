{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        profiles.default = {
          extensions =
            with pkgs.vscode-marketplace;
            [
              albert.tabout
              antfu.icons-carbon
              asvetliakov.vscode-neovim
              bierner.markdown-mermaid
              copilot-arena.copilot-arena
              cschlosser.doxdocgen
              editorconfig.editorconfig
              foam.foam-vscode
              gruntfuggly.todo-tree
              hars.cppsnippets
              james-yu.latex-workshop
              jasonlhy.hungry-delete
              jnoortheen.nix-ide
              juanblanco.solidity
              llvm-vs-code-extensions.vscode-clangd
              ms-azuretools.vscode-containers
              ms-azuretools.vscode-docker
              ms-python.black-formatter
              ms-python.debugpy
              ms-python.python
              ms-python.vscode-pylance
              ms-python.vscode-python-envs
              ms-toolsai.jupyter
              ms-toolsai.jupyter-keymap
              ms-toolsai.jupyter-renderers
              ms-toolsai.vscode-jupyter-cell-tags
              ms-toolsai.vscode-jupyter-slideshow
              ms-vscode.cmake-tools
              ms-vscode.hexeditor
              ms-vscode.remote-explorer
              ms-vscode-remote.remote-containers
              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit
              ms-vsliveshare.vsliveshare
              myriad-dreamin.tinymist
              nmsmith89.incrementor
              redhat.java
              redhat.vscode-yaml
              remisa.shellman
              robole.markdown-shortcuts
              rust-lang.rust-analyzer
              streetsidesoftware.code-spell-checker
              tamasfe.even-better-toml
              thomanq.math-snippets
              usernamehw.errorlens
              vscjava.vscode-java-debug
              vscjava.vscode-java-test
              vscjava.vscode-maven
              xaver.clang-format
              yfzhao.hscopes-booster
              yfzhao.ultra-math-preview
              yzhang.markdown-all-in-one
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              # https://github.com/nix-community/nix-vscode-extensions/issues/143
              {
                name = "vscode-lldb";
                publisher = "vadimcn";
                version = "1.11.6";
                sha256 = "sha256-E4gMoAbI+D0xAFNG6j3pHzOMbhB9CWVCeqFEb4qlSu8=";
              }
            ];

          # User settings (settings.json)
          userSettings = {
            # Editor Settings
            "explorer.confirmDelete" = false;
            "explorer.confirmDragAndDrop" = false;
            "editor.smoothScrolling" = true;
            "window.openFoldersInNewWindow" = "on";
            "editor.cursorSmoothCaretAnimation" = "on";
            "editor.cursorBlinking" = "smooth";
            "editor.minimap.autohide" = "mouseover";
            "editor.desktopdes.bracketPairs" = true;
            "editor.autoClosingOvertype" = "always";
            "editor.linkedEditing" = true;
            "editor.suggest.snippetsPreventQuickSuggestions" = false;
            "diffEditor.ignoreTrimWhitespace" = true;
            "editor.suggestSelection" = "recentlyUsed";
            "editor.renderLineHighlight" = "none";
            "editor.matchBrackets" = "never";
            "editor.quickSuggestionsDelay" = 0;
            "editor.unicodeHighlight.allowedLocales" = {
              "zh_cn" = true;
            };
            "git.terminalAuthentication" = false;
            "github.gitAuthentication" = false;
            "window.restoreWindows" = "none";
            "git.openRepositoryInParentFolders" = "always";
            "git.blame.statusBarItem.enabled" = true;

            # Terminal
            "terminal.integrated.enableFileLinks" = "off";

            # Files
            "files.autoGuessEncoding" = true;
            "files.trimFinalNewlines" = true;

            # Workbench
            "workbench.list.smoothScrolling" = true;
            "workbench.editorAssociations" = {
              "*.pdf" = "latex-workshop-pdf-hook";
            };
            "workbench.startupEditor" = "none";
            "workbench.editor.labelFormat" = "medium";
            "workbench.tips.enabled" = false;
            "workbench.productIconTheme" = "icons-carbon";
            "workbench.tree.renderIndentGuides" = "none";

            # Online Services
            "workbench.enableExperiments" = false;
            "workbench.settings.enableNaturalLanguageSearch" = false;
            "extensions.ignoreRecommendations" = true;
            "telemetry.telemetryLevel" = "off";
            "telemetry.feedback.enabled" = false;
            "typescript.surveys.enabled" = false;
            "update.mode" = "none";
            "workbench.cloudChanges.autoResume" = "off";
            "workbench.cloudChanges.continueOn" = "off";
            "redhat.telemetry.enabled" = false;
            "update.showReleaseNotes" = false;
            "workbench.welcomePage.walkthroughs.openOnInstall" = false;
            "settingsSync.keybindingsPerPlatform" = false;
            "npm.fetchOnlinePackageInfo" = false;
            "extensions.autoUpdate" = false;
            "git.ignoreLegacyWarning" = true;
            "git.confirmSync" = false;
            "git.suggestSmartCommit" = false;
            "typescript.disableAutomaticTypeAcquisition" = true;

            # Notebook
            "notebook.lineNumbers" = "on";

            # Markdown
            "markdown.extension.list.indentationSize" = "inherit";
            "markdown.extension.print.theme" = "dark";
            "markdown.updateLinksOnFileMove.enabled" = "prompt";

            "javascript.inlayHints.parameterNames.enabled" = "all";
            "javascript.updateImportsOnFileMove.enabled" = "always";

            "clangd.arguments" = [
              "--background-index"
              "--compile-commands-dir=\${workspaceFolder}"
              "--clang-tidy"
              "--completion-style=detailed"
              "--enable-config"
              "--pretty"
            ];
            "clangd.fallbackFlags" = [
              "-Wall"
              "-Werror"
              "-Wextra"
              "-Wpedantic"
              "-Wvla"
              "-Wextra-semi"
              "-Wnull-dereference"
              "-Wsuggest-override"
              "-Wconversion"
            ];
            "clangd.checkUpdates" = false;

            "clang-format.style" = "Webkit";
            "[cpp]" = {
              "editor.defaultFormatter" = "xaver.clang-format";
            };
            "[c]" = {
              "editor.defaultFormatter" = "xaver.clang-format";
            };

            "latex-workshop.latex.outDir" = "%DIR%/latex-build";
            "latex-workshop.latex.recipes" = [
              {
                name = "tectonic";
                tools = [ "tectonic" ];
              }
              {
                name = "latexmk";
                tools = [ "latexmk" ];
              }
            ];
            "latex-workshop.latex.tools" = [
              {
                name = "tectonic";
                command = "tectonic";
                args = [
                  "--synctex"
                  "--outdir=%OUTDIR%"
                  "-Z"
                  "continue-on-errors"
                  "%DOC_EXT%"
                ];
                env = { };
              }
              {
                name = "latexmk";
                command = "latexmk";
                args = [
                  "-synctex=1"
                  "-interaction=nonstopmode"
                  "-file-line-error"
                  "-pdf"
                  "-outdir=%OUTDIR%"
                  "%DOC%"
                ];
                env = { };
              }
            ];
            "latex-workshop.view.pdf.internal.synctex.keybinding" = "double-click";
            "latex-workshop.latex.autoBuild.run" = "never";
            "latex-workshop.formatting.latex" = "latexindent";
            "[latex]" = {
              "editor.wordWrap" = "on";
              "editor.desktopdes.bracketPairs" = false;
              "editor.defaultFormatter" = "James-Yu.latex-workshop";
            };

            "python.experiments.enabled" = false;
            "python.testing.pytestEnabled" = true;
            "python.analysis.typeCheckingMode" = "basic";
            "jupyter.experiments.enabled" = false;
            "python.analysis.diagnosticMode" = "workspace";
            "python.analysis.inlayHints.variableTypes" = true;
            "python.analysis.inlayHints.functionReturnTypes" = true;
            "python.terminal.activateEnvironment" = false;
            "[python]" = {
              "editor.defaultFormatter" = "ms-python.black-formatter";
            };
            "python.analysis.completeFunctionParens" = true;

            "cmake.configureOnOpen" = true;
            "cmake.showOptionsMovedNotification" = false;

            "lldb.launch.terminal" = "integrated";

            # Neovim
            "extensions.experimental.affinity" = {
              "asvetliakov.vscode-neovim" = 1;
            };

            # Typst
            "tinymist.formatterMode" = "typstyle";
            "tinymist.formatterIndentSize" = 4;

            "[typst]" = {
              "editor.wordWrap" = "on";
              "editor.wordSeparators" = ''`~!@#$%^&*()=+[{]}\|;:'",.<>/?'';
            };
            "[typst-code]" = {
              "editor.wordSeparators" = ''`~!@#$%^&*()=+[{]}\|;:'",.<>/?'';
            };

            "[java]" = {
              "editor.defaultFormatter" = "redhat.java";
            };

            "[javascript]" = {
              "editor.defaultFormatter" = "vscode.typescript-language-features";
            };

            "[typescript]" = {
              "editor.defaultFormatter" = "vscode.typescript-language-features";
            };

            # Copilot Arena
            "arena.codePrivacySettings" = "Private";
            "arena.enableTabAutocomplete" = false;

            # TabOut
            "tabout.charactersToTabOutFrom" = [
              {
                open = "[";
                close = "]";
              }
              {
                open = "{";
                close = "}";
              }
              {
                open = "(";
                close = ")";
              }
              {
                open = "'";
                close = "'";
              }
              {
                open = ''"'';
                close = ''"'';
              }
              {
                open = ":";
                close = ":";
              }
              {
                open = "=";
                close = "=";
              }
              {
                open = ">";
                close = ">";
              }
              {
                open = "<";
                close = "<";
              }
              {
                open = ".";
                close = ".";
              }
              {
                open = "`";
                close = "`";
              }
              {
                open = ";";
                close = ";";
              }
              {
                open = "$";
                close = "$";
              }
              {
                open = "*";
                close = "*";
              }
            ];

            # Ultra Math
            "umath.preview.EnableCursor" = false;
            "umath.preview.renderer" = "katex";

            # nix
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";

            # chat
            "chat.agent.enabled" = false;
            "chat.disableAIFeatures" = true;
            "chat.commandCenter.enabled" = false;

            # Minimalistic
            "window.commandCenter" = false;
            "window.menuBarVisibility" = "hidden";
            "workbench.editor.enablePreview" = false;
            "workbench.layoutControl.enabled" = false;
            "explorer.compactFolders" = false;
            "explorer.autoReveal" = "focusNoScroll";
            "editor.inlineSuggest.enabled" = true;
            "workbench.tree.enableStickyScroll" = false;
            "editor.stickyScroll.enabled" = false;
            "workbench.activityBar.location" = "top";
            "window.titleBarStyle" = "native";
            "window.menuStyle" = "custom";
            "window.customTitleBarVisibility" = "never";
            "umath.preview.AutoAdjustPreviewPosition" = false;
            "workbench.secondarySideBar.defaultVisibility" = "hidden";
          };

          # Keybindings (keybindings.json)
          keybindings = [
            # Use ctrl+j/k to select quick fix/suggestion
            {
              key = "ctrl+j";
              command = "selectNextQuickFix";
              when = "editorFocus && quickFixWidgetVisible";
            }
            {
              key = "ctrl+k";
              command = "selectPrevQuickFix";
              when = "editorFocus && quickFixWidgetVisible";
            }
            {
              key = "ctrl+j";
              command = "selectNextSuggestion";
              when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
            }
            {
              key = "ctrl+k";
              command = "selectPrevSuggestion";
              when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
            }

            # Move lines up/down
            {
              key = "ctrl+shift+j";
              command = "editor.action.moveLinesDownAction";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "ctrl+shift+k";
              command = "editor.action.moveLinesUpAction";
              when = "editorTextFocus && !editorReadonly";
            }

            # File/Folder creation
            {
              key = "n";
              command = "workbench.files.action.createFileFromExplorer";
              when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
            }
            {
              key = "shift+n";
              command = "workbench.files.action.createFolderFromExplorer";
              when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
            }

            # Free Copy, Close (on insert), Select all (on insert)
            {
              key = "ctrl+c";
              command = "-vscode-neovim.escape";
              when = "editorTextFocus && neovim.ctrlKeysNormal.c && neovim.init && !dirtyDiffVisible && !findWidgetVisible && !inReferenceSearchEditor && !markersNavigationVisible && !notebookCellFocused && !notificationCenterVisible && !parameterHintsVisible && !referenceSearchVisible && neovim.mode == 'normal' && editorLangId not in 'neovim.editorLangIdExclusions'";
            }
            {
              key = "ctrl+c";
              command = "-vscode-neovim.escape";
              when = "editorTextFocus && neovim.ctrlKeysInsert.c && neovim.init && neovim.mode != 'normal' && editorLangId not in 'neovim.editorLangIdExclusions'";
            }
            {
              key = "ctrl+w";
              command = "-vscode-neovim.send";
              when = "editorTextFocus && neovim.ctrlKeysInsert.w && neovim.init && neovim.mode == 'insert' && editorLangId not in 'neovim.editorLangIdExclusions'";
            }
            {
              key = "ctrl+a";
              command = "-vscode-neovim.send";
              when = "editorTextFocus && neovim.ctrlKeysInsert.a && neovim.init && neovim.mode == 'insert' && editorLangId not in 'neovim.editorLangIdExclusions'";
            }

            # Copilot Arena
            {
              key = "ctrl+shift+.";
              command = "arena.promptToDiff";
              when = "editorTextFocus";
            }

            # Snippets
            {
              key = "ctrl+m ctrl+m";
              command = "editor.action.insertSnippet";
              args = {
                name = "Insert Inline Math";
              };
              when = "editorTextFocus && !editorReadonly && editorLangId == 'latex'";
            }
            {
              key = "ctrl+shift+m";
              command = "editor.action.insertSnippet";
              args = {
                name = "Insert Display Math";
              };
              when = "editorTextFocus && !editorReadonly && editorLangId == 'latex'";
            }
            {
              key = "ctrl+m ctrl+m";
              command = "editor.action.insertSnippet";
              args = {
                name = "Insert Inline Math";
              };
              when = "editorTextFocus && !editorReadonly && editorLangId == 'typst'";
            }
            {
              key = "ctrl+shift+m";
              command = "editor.action.insertSnippet";
              args = {
                name = "Insert Display Math";
              };
              when = "editorTextFocus && !editorReadonly && editorLangId == 'typst'";
            }
            {
              key = "ctrl+m ctrl+m";
              command = "editor.action.insertSnippet";
              args = {
                name = "Insert Inline Math";
              };
              when = "editorTextFocus && !editorReadonly && editorLangId == 'markdown'";
            }
            {
              key = "ctrl+shift+m";
              command = "editor.action.insertSnippet";
              args = {
                name = "Insert Display Math";
              };
              when = "editorTextFocus && !editorReadonly && editorLangId == 'markdown'";
            }
            {
              key = "ctrl+j";
              command = "editor.action.triggerSuggest";
              when = "editorHasCompletionItemProvider && textInputFocus && !editorReadonly && !suggestWidgetVisible";
            }

            # Allow arrow keys in neovim normal mode
            {
              key = "up";
              command = "cursorUp";
              when = "editorTextFocus && neovim.mode == 'normal' && !inDebugRepl && !suggestWidgetMultipleSuggestions && !suggestWidgetVisible";
            }
            {
              key = "down";
              command = "cursorDown";
              when = "editorTextFocus && neovim.mode == 'normal' && !inDebugRepl && !suggestWidgetMultipleSuggestions && !suggestWidgetVisible";
            }
          ];

          languageSnippets = {
            latex = {
              "Insert Inline Math" = {
                "prefix" = "inlineMath";
                "body" = [ "\${1:$\${2:}$$0}" ];
                "description" = "Insert inline math block $$ $$ with easy backspace delete";
              };
              "Insert Display Math" = {
                "prefix" = "displayMath";
                "body" = [
                  "\${1:\\["
                  "    \${2:}"
                  "\\]}$0"
                ];
                "description" = "Insert 3-line display math block with cursor inside";
              };
            };
            markdown = {
              "Insert Inline Math" = {
                "prefix" = "inlineMath";
                "body" = [ "\${1:$\${2:}$$0}" ];
                "description" = "Insert inline math block $$ $$ with easy backspace delete";
              };
              "Insert Display Math" = {
                "prefix" = "displayMath";
                "body" = [
                  "\${1:$$"
                  "    \${2:}"
                  "$$}$0"
                ];
                "description" = "Insert 3-line display math block with cursor inside";
              };
            };
            typst = {
              "Insert Inline Math" = {
                "prefix" = "inlineMath";
                "body" = [ "\${1:$\${2:}$$0}" ];
                "description" = "Insert inline math block $$ $$ with easy backspace delete";
              };
              "Insert Display Math" = {
                "prefix" = "displayMath";
                "body" = [
                  "\${1:$$"
                  "    \${2:}"
                  "$$}$0"
                ];
                "description" = "Insert 3-line display math block with cursor inside";
              };
            };
          };
        };
      };

      # Dependencies for extensions
      home.packages = with pkgs; [
        black
        clang-tools
        nixfmt
        nixd
        tectonic
        (texliveSmall.withPackages (
          ps: with ps; [
            latexindent
            synctex
          ]
        ))
        typst
      ];

      # Ensure Neovim is installed for vscode-neovim
      programs.neovim.enable = true;
    };
}
