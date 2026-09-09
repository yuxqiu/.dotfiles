{
  flake.modules.homeManager.vscode =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.vscode.profiles.default.extensions = lib.mkIf (config.my.dev.languages ? lean) (
        with pkgs.vscode-marketplace; [ leanprover.lean4 ]
      );
    };
}
