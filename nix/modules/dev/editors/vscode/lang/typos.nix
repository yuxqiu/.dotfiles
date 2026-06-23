{
  flake.modules.homeManager.vscode =
    { pkgs, config, lib, ... }:
    {
      programs.vscode.profiles.default.extensions = lib.mkIf (config.my.dev.languages ? typos) (
        with pkgs.vscode-marketplace;
        [ streetsidesoftware.code-spell-checker ]
      );
    };
}
