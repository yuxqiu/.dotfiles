{
  flake.modules.homeManager.vscode =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.vscode.profiles.default.userSettings = lib.mkIf (config.my.dev.languages ? typescript) {
        "javascript.inlayHints.parameterNames.enabled" = "all";
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
      };
    };
}
