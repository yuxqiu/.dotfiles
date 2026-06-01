{
  lib,
  config,
  self,
  inputs,
  ...
}:
let
  flakeRef = "${self.outPath}";
  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      inherit (config.nixpkgs) config overlays;
    };

  mkHmConfigsForSystem =
    system: lib.filterAttrs (_: cfg: cfg.system == system) config.configurations.homeManager;
  mkSmConfigsForSystem =
    system: lib.filterAttrs (_: cfg: cfg.system == system) config.configurations.systemManager;
  mkNixosConfigsForSystem =
    system: lib.filterAttrs (_: cfg: cfg.system == system) config.configurations.nixos;
in
{
  config.flake = {
    apps = lib.genAttrs config.systems (
      system:
      let
        hmConfigs = mkHmConfigsForSystem system;
        smConfigs = mkSmConfigsForSystem system;
        nixosConfigs = mkNixosConfigsForSystem system;
        pkgs = mkPkgs system;

        hmApps = lib.mapAttrs' (
          name: _:
          let
            appName = "hm-${name}";
            script = pkgs.writeShellApplication {
              name = appName;
              runtimeInputs = [ pkgs.nix ];
              text = ''
                exec nix run ${inputs.home-manager} -- switch --flake "${flakeRef}#${name}"
              '';
            };
          in
          lib.nameValuePair appName {
            type = "app";
            program = "${script}/bin/${appName}";
          }
        ) hmConfigs;

        smApps = lib.mapAttrs' (
          name: _:
          let
            appName = "sm-${name}";
            script = pkgs.writeShellApplication {
              name = appName;
              runtimeInputs = [ pkgs.nix ];
              text = ''
                exec nix run ${inputs.system-manager} -- switch --flake "${flakeRef}#${name}" --sudo
              '';
            };
          in
          lib.nameValuePair appName {
            type = "app";
            program = "${script}/bin/${appName}";
          }
        ) smConfigs;

        nixosApps = lib.mapAttrs' (
          name: _:
          let
            appName = "nixos-${name}";
            script = pkgs.writeShellApplication {
              name = appName;
              runtimeInputs = [ pkgs.nix ];
              text = ''
                exec nixos-rebuild switch --flake "${flakeRef}#${name}" --use-remote-sudo "$@"
              '';
            };
          in
          lib.nameValuePair appName {
            type = "app";
            program = "${script}/bin/${appName}";
          }
        ) nixosConfigs;
      in
      hmApps // smApps // nixosApps
    );

    checks = lib.genAttrs config.systems (
      system:
      let
        hmConfigs = mkHmConfigsForSystem system;
        smConfigs = mkSmConfigsForSystem system;
        nixosConfigs = mkNixosConfigsForSystem system;
        pkgs = mkPkgs system;

        hmChecks = lib.mapAttrs' (
          name: _:
          lib.nameValuePair "home-${name}" (
            pkgs.runCommandNoCC "check-home-${name}" { } ''
              test -e ${config.flake.homeConfigurations.${name}.activationPackage}
              touch "$out"
            ''
          )
        ) hmConfigs;

        smChecks = lib.mapAttrs' (
          name: _:
          lib.nameValuePair "system-${name}" (
            pkgs.runCommandNoCC "check-system-${name}" { } ''
              test -e ${config.flake.systemConfigs.${name}}
              touch "$out"
            ''
          )
        ) smConfigs;

        nixosChecks = lib.mapAttrs' (
          name: _:
          lib.nameValuePair "nixos-${name}" (
            pkgs.runCommandNoCC "check-nixos-${name}" { }
              ''
                test -e ${config.flake.nixosConfigurations.${name}.config.system.build.toplevel}
                touch "$out"
              ''
          )
        ) nixosConfigs;
      in
      hmChecks // smChecks // nixosChecks
    );

    formatter = lib.genAttrs config.systems (system: (mkPkgs system).nixfmt-tree);
  };
}
