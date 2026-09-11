{
  config,
  ...
}:

{
  configurations.nixos = {
    "snowflake-dracaena" = {
      system = "aarch64-linux";
      stateVersion = "26.11";
      modules = [
        config.flake.modules.generic.base
        config.flake.modules.generic.yuxqiu

        # base
        config.flake.modules.nixos.base

        # networking
        config.flake.modules.nixos.dns
        config.flake.modules.nixos.networking
        config.flake.modules.nixos.firewall

        # security
        config.flake.modules.nixos.sysctl
        config.flake.modules.nixos.coredump

        # services
        config.flake.modules.nixos.journald
        config.flake.modules.nixos.fstrim

        config.flake.modules.nixos.snowflake-dracaena
      ];
    };
  };
}
