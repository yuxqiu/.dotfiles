{ inputs, ... }:
{
  flake.modules.homeManager.linux-desktop =
    { pkgs, lib, ... }:
    let
      # Copied from
      # - https://github.com/meatcar/dots/blob/main/home-manager/modules/voice/handy/default.nix
      handyUpstream = inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Upstream bunDeps hash doesn't match when following our nixpkgs (different bun version).
      # Rebuild with the correct hash until upstream updates.
      fixedBunDeps = pkgs.stdenv.mkDerivation {
        pname = "handy-bun-deps";
        inherit (handyUpstream) version;
        src = inputs.handy;
        nativeBuildInputs = [
          pkgs.bun
          pkgs.cacert
        ];
        dontFixup = true;
        buildPhase = ''
          export HOME=$TMPDIR
          bun install --frozen-lockfile --no-progress
        '';
        installPhase = ''
          mkdir -p $out
          cp -r node_modules $out/
        '';
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = "sha256-6SvLw/8UBIHlcIY7jUJKv6DHPooP3aUz+4PvC7UNzv4=";
      };

      handy = handyUpstream.overrideAttrs (_old: {
        preBuild = ''
          cp -r ${fixedBunDeps}/node_modules node_modules
          chmod -R +w node_modules
          substituteInPlace node_modules/.bin/{tsc,vite} \
            --replace-fail "/usr/bin/env node" "${lib.getExe pkgs.bun}"
          export HOME=$TMPDIR
          bun run build
        '';
      });
    in
    {
      home.packages = [
        handy
        pkgs.dotool
      ];

      systemd.user.services.handy = {
        Unit = {
          Description = "Handy speech-to-text";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service =
          let
            combinedAlsaPlugins = pkgs.symlinkJoin {
              name = "combined-alsa-plugins";
              paths = [
                "${pkgs.pipewire}/lib/alsa-lib"
                "${pkgs.alsa-lib-with-plugins}/lib/alsa-lib"
              ];
            };
          in
          {
            Type = "simple";
            ExecStart = "${handy}/bin/handy --start-hidden";
            Restart = "on-failure";
            RestartSec = 3;
            Environment = [
              "ALSA_PLUGIN_DIR=${combinedAlsaPlugins}"
            ];
          };
      };
    };
}
