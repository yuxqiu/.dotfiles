{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        # needed by extensions to support offline lsp
        # - Some from https://github.com/zed-industries/zed/tree/main/crates/languages/src
        extraPackages = with pkgs; [
          basedpyright
          clang-tools
          gopls
          markdown-oxide
          nixd
          nixfmt
          package-version-server
          vscode-json-languageserver
          ruff
          tectonic
          texlab
          (texliveSmall.withPackages (
            ps: with ps; [
              latexindent
              synctex
            ]
          ))
          typos-lsp
          tinymist
        ];
        userSettings = {
          agent = {
            button = false;
          };
          auto_update = false;
          base_keymap = "VSCode";
          collaboration_panel = {
            button = false;
          };
          colorize_brackets = true;
          disable_ai = true;
          format_on_save = "on";
          inlay_hints = {
            enabled = true;
          };
          languages = {
            BibTeX = {
              formatter = {
                external = {
                  command = "latexindent";
                  arguments = [
                    "-l"
                    "-g"
                    "/dev/null"
                  ];
                };
              };
            };
            Markdown = {
              format_on_save = "on";
            };
            LaTeX = {
              soft_wrap = "editor_width";
            };
            Typst = {
              soft_wrap = "editor_width";
            };
            Nix = {
              language_servers = [
                "nixd"
                "!nil"
              ];
              formatter = {
                external = {
                  command = "nixfmt";
                };
              };
            };
          };
          lsp = {
            tinymist = {
              settings = {
                exportPdf = "onSave";
              };
            };
            texlab = {
              settings = {
                texlab = {
                  build = {
                    onSave = true;
                    forwardSearchAfter = true;
                    executable = "tectonic";
                    args = [
                      "-X"
                      "compile"
                      "%f"
                      "--untrusted"
                      "--synctex"
                      "--keep-logs"
                      "--keep-intermediates"
                    ];
                  };
                };
              };
            };
          };
          minimap = {
            show = "auto";
          };
          tabs = {
            "file_icons" = true;
          };
          telemetry = {
            metrics = false;
            diagnostics = false;
          };
          title_bar = {
            show_onboarding_banner = false;
            show_user_picture = false;
            show_sign_in = false;
          };
          toolbar = {
            agent_review = false;
          };
          vim_mode = true;
          vim = {
            toggle_relative_line_numbers = true;
          };
        };
        userKeymaps = [
          {
            "context" = "vim_mode == insert";
            "bindings" = {
              "ctrl-c" = "editor::Copy";
              "ctrl-s" = "workspace::Save";
              "ctrl-x" = "editor::Cut";
              "ctrl-v" = "editor::Paste";
              "ctrl-w" = "pane::CloseActiveItem";
              "ctrl-shift-k" = "editor::MoveLineUp";
              "ctrl-shift-j" = "editor::MoveLineDown";
            };
          }
          {
            # disable agent panel
            "context" = "!Terminal";
            "bindings" = {
              "ctrl-shift-c" = null;
            };
          }
          {
            "context" = "(ProjectPanel && not_editing)";
            "bindings" = {
              "n" = "project_panel::NewFile";
              "shift-n" = "project_panel::NewDirectory";
              "d" = "project_panel::Delete";
              "r" = "project_panel::Rename";
            };
          }
          {
            "context" = "Editor && (showing_code_actions || showing_completions)";
            "bindings" = {
              "ctrl-j" = "editor::ContextMenuNext";
              "ctrl-k" = "editor::ContextMenuPrevious";
            };
          }
          {
            "bindings" = {
              "ctrl-o" = [
                "projects::OpenRecent"
                {
                  "create_new_window" = true;
                }
              ];
            };
          }
          {
            "context" = "vim_mode == normal || vim_mode == visual";
            "bindings" = {
              "s" = "vim::PushSneak";
              "shift-s" = "vim::PushSneakBackward";
            };
          }
        ];
        extensions = [
          "one-dark-pro"
          "markdown-oxide"
          "typst"
          "latex"
          "nix"
          "typos"
          "editorconfig"
        ];
        installRemoteServer = false;
      };

      # snippets
      xdg.configFile."zed/snippets".source = ./snippets;

      # stylix: use zed dynamic theme
      stylix.targets.zed.colors.enable = false;
    };
}
