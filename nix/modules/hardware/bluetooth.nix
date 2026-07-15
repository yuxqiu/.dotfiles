{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          UserspaceHID = true;
        };
      };
    };
  };

  flake.modules.homeManager.bluetooth =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.blueman ];

      # Prevent blueman-applet tray icon from autostarting.
      # blueman-manager is still available on demand.
      xdg.configFile."autostart/blueman.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Blueman Applet
        Hidden=true
      '';
    };
}
