{ inputs, ... }:
{
  flake.modules.homeManager.linux-base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        iputils
        patch
        traceroute

        inputs.system-manager.packages.${pkgs.stdenv.system}.default
      ];

      # improve generic linux compatibility (on non NixOS)
      targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
      targets.genericLinux.gpu.enable = false; # already managed by system-manager
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
