{
  flake.modules.homeManager.vscode =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.vscode.profiles.default.extensions = lib.mkIf (config.my.dev.languages ? toml) (
        with pkgs.vscode-marketplace; [ tamasfe.even-better-toml ]
      );
    };
}
