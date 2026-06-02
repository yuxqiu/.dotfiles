{ inputs, ... }:
{
  flake.modules.nixos.paseo =
    {
      config,
      pkgs,
      ...
    }:
    let
      upstreamPkg = inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system}.default;
      correctHash = "sha256-ipuV4cM3LUqMQ39LyB4X3ezz5UgxyHGEhpBOq7en2Jw=";
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

      services.tailscale.serve = {
        services.paseo = {
          endpoints = {
            "tcp:6767" = "tcp://127.0.0.1:6767";
          };
        };
      };
    };
}
