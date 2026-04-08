{ inputs, ... }:
{
  flake.modules.homeManager.linux-base =
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
      targets.genericLinux.gpu.enable = lib.mkIf config.my.system.isSystemManager false; # already managed by system-manager
    };

  flake.modules.homeManager.linux-desktop =
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
