{
  flake.modules.homeManager.linux-base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        iputils
        patch
        system-manager
        traceroute
      ];

      # improve generic linux compatibility (on non NixOS)
      targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
      targets.genericLinux.gpu.enable = false; # already managed by system-manager
    };

  flake.modules.homeManager.linux-gui =
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
