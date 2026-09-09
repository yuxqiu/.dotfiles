{
  inputs,
  ...
}:
{
  flake.modules.homeManager.dms =
    { pkgs, ... }:
    let
      codeburn = pkgs.callPackage (inputs.self + /packages/codeburn.nix) { };
    in
    {
      programs.dank-material-shell.plugins.codeburn = {
        enable = true;
        # Point the provider script at the store path directly so it doesn't
        # depend on the DMS systemd service inheriting the HM profile PATH.
        settings = {
          cliPath = "${codeburn}/bin/codeburn";
          compactMode = true;
        };
      };

      home.packages = [
        codeburn
        pkgs.jq
      ];
    };
}
