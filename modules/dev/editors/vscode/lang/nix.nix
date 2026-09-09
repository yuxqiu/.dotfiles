{
  flake.modules.homeManager.vscode =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.vscode.profiles.default.extensions = lib.mkIf (config.my.dev.languages ? nix) (
        with pkgs.vscode-marketplace; [ jnoortheen.nix-ide ]
      );

      programs.vscode.profiles.default.userSettings = lib.mkIf (config.my.dev.languages ? nix) {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
      };
    };
}
