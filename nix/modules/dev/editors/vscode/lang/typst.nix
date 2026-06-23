{
  flake.modules.homeManager.vscode =
    { pkgs, config, lib, ... }:
    {
      programs.vscode.profiles.default.extensions = lib.mkIf (config.my.dev.languages ? typst) (
        with pkgs.vscode-marketplace;
        [ myriad-dreamin.tinymist ]
      );

      programs.vscode.profiles.default.userSettings = lib.mkIf (config.my.dev.languages ? typst) {
        "tinymist.formatterMode" = "typstyle";
        "tinymist.formatterIndentSize" = 4;
        "[typst]" = {
          "editor.wordWrap" = "on";
          "editor.wordSeparators" = ''`~!@#$%^&*()=+[{]}\|;:'",.<>/?'';
        };
        "[typst-code]" = {
          "editor.wordSeparators" = ''`~!@#$%^&*()=+[{]}\|;:'",.<>/?'';
        };
      };

      programs.vscode.profiles.default.keybindings = lib.mkIf (config.my.dev.languages ? typst) [
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
      ];

      programs.vscode.profiles.default.languageSnippets = lib.mkIf (config.my.dev.languages ? typst) {
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
}
