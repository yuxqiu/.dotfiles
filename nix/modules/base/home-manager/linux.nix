{ inputs, ... }:
{
  flake.modules.homeManager.base-linux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages =
        with pkgs;
        [
          iputils
          patch
          traceroute
        ]
        ++ lib.optional config.my.system.isSystemManager (
          inputs.system-manager.packages.${pkgs.stdenv.system}.default
        );

      # improve generic linux compatibility (on non NixOS)
      targets.genericLinux.enable = !config.my.system.isNixos;
      targets.genericLinux.gpu.enable = lib.mkIf config.my.system.isSystemManager false;
    };

  flake.modules.homeManager.base-linux-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        blueman
        desktop-file-utils
        libnotify
        networkmanager
        xdg-utils
      ];
    };
}
