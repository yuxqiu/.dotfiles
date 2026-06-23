{
  flake.modules.homeManager.vscode =
    { pkgs, config, lib, ... }:
    {
      programs.vscode.profiles.default.extensions =
        lib.mkIf (config.my.dev.languages ? rust)
          (with pkgs.vscode-marketplace; [ rust-lang.rust-analyzer ])
        ++ lib.mkIf (config.my.dev.languages ? rust)
          (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # https://github.com/nix-community/nix-vscode-extensions/issues/143
            {
              name = "vscode-lldb";
              publisher = "vadimcn";
              version = "1.11.6";
              sha256 = "sha256-E4gMoAbI+D0xAFNG6j3pHzOMbhB9CWVCeqFEb4qlSu8=";
            }
          ]);

      programs.vscode.profiles.default.userSettings = lib.mkIf (config.my.dev.languages ? rust) {
        "lldb.launch.terminal" = "integrated";
      };
    };
}
