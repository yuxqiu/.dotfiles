{
  flake.modules.homeManager.vscode =
    { pkgs, config, lib, ... }:
    {
      programs.vscode.profiles.default.extensions = lib.mkIf (config.my.dev.languages ? markdown) (
        with pkgs.vscode-marketplace;
        [
          bierner.markdown-mermaid
          foam.foam-vscode
          robole.markdown-shortcuts
          yzhang.markdown-all-in-one
        ]
      );

      programs.vscode.profiles.default.userSettings = lib.mkIf (config.my.dev.languages ? markdown) {
        "markdown.extension.list.indentationSize" = "inherit";
        "markdown.extension.print.theme" = "dark";
        "markdown.updateLinksOnFileMove.enabled" = "prompt";
      };

      programs.vscode.profiles.default.keybindings = lib.mkIf (config.my.dev.languages ? markdown) [
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
      ];

      programs.vscode.profiles.default.languageSnippets = lib.mkIf (config.my.dev.languages ? markdown) {
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
      };
    };
}
