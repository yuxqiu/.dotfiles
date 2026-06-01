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
      home.packages = with pkgs; [
        iputils
        patch
        traceroute
      ];

      targets.genericLinux.enable = !config.my.system.isNixos;
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
