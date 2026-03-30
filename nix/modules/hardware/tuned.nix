{
  flake.modules.systemManager.desktop =
    {
      nixosModulesPath,
      lib,
      ...
    }:
    {
      imports = [
        (nixosModulesPath + "/services/hardware/tuned.nix")
      ];

      # tuned upstream checks if these services are enabled
      # as they are not compatible with tuned. Here, we define
      # them to make the check pass.
      options = {
        hardware.system76.power-daemon = lib.mkOption {
          type = lib.types.raw;
          default = {
            enable = false;
          };
        };
        services.auto-cpufreq = lib.mkOption {
          type = lib.types.raw;
          default = {
            enable = false;
          };
        };
        services.power-profiles-daemon = lib.mkOption {
          type = lib.types.raw;
          default = {
            enable = false;
          };
        };
        services.tlp = lib.mkOption {
          type = lib.types.raw;
          default = {
            enable = false;
          };
        };
      };

      config.services.tuned = {
        enable = true;
        settings = {
          dynamic_tuning = true;
        };
      };
    };
}
