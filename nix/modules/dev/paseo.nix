{ inputs, ... }:
{
  flake.modules.systemManager.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      upstreamPkg = inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system}.default;
      correctHash = "sha256-kw9Lefo644oeeTJCvdFdeW4tbwVMQWqkIVaNonhqbNs=";
      fixedNpmDeps = upstreamPkg.npmDeps.overrideAttrs {
        outputHash = correctHash;
      };
      paseoPkg = upstreamPkg.overrideAttrs {
        npmDeps = fixedNpmDeps;
      };
    in
    {
      imports = [ inputs.paseo.nixosModules.default ];

      services.paseo = {
        enable = true;
        package = paseoPkg;
        user = config.my.username;
        group = "users";
        port = 6767;
        listenAddress = "127.0.0.1";
        relay.enable = false;
        hostnames = [ "${config.my.networking.publicHost}" ];
      };

      services.tailscale.serveHttpsTargets = lib.mkIf config.services.paseo.enable {
        "6767" = "http://127.0.0.1:6767";
      };
    };
}
