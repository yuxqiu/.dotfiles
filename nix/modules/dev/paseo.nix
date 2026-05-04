{ inputs, ... }:
{
  flake.modules.systemManager.paseo =
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

      # Add user's path to the daemon's PATH
      systemd.services.paseo.environment.PATH = lib.mkOverride 10 (
        lib.concatStringsSep ":" [
          "${config.users.users.${config.my.username}.home}/.nix-profile/bin"
        ]
      );

      services.tailscale.serve.endpoints = lib.mkIf config.services.paseo.enable {
        "tcp:6767" = "tcp://127.0.0.1:6767";
      };
    };
}
