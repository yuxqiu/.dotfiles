{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    userSettings = {
      agent = {
        button = false;
      };
      auto_update = false;
      base_keymap = "VSCode";
      buffer_font_size = 16;
      collaboration_panel = {
        button = false;
      };
      colorize_brackets = true;
      disable_ai = true;
      languages = {
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
            outputPath = "$root/$name";
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
      ui_font_size = 16;
      vim_mode = true;
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
        };
      }
      {
        "context" = "Editor && (showing_code_actions || showing_completions)";
        "bindings" = {
          "ctrl-j" = "editor::ContextMenuNext";
          "ctrl-k" = "editor::ContextMenuPrevious";
        };
      }
    ];
    extensions = [
      "one-dark-pro"
      "markdown-oxide"
      "typst"
      "latex"
      "texpresso"
      "nix"
      "typos"
      "editorconfig"
      "java"
    ];
    mutableUserSettings = false;
    mutableUserKeymaps = false;
    installRemoteServer = false;
  };

  # snippets
  xdg.configFile."snippets".source = ./snippets;
}
