{
  flake.modules.nixos.ios =
    { pkgs, ... }:
    {
      services.usbmuxd.enable = true;

      programs.fuse.userAllowOther = true;

      environment.systemPackages = [
        pkgs.ifuse
        pkgs.libimobiledevice
      ];
    };
}
