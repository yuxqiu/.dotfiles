{
  flake.modules.nixos.yuxqiu-cedrus = {
    # Host-specific USB device whitelist
    # Blocks all USB devices by default; only listed devices are allowed.
    # Run `lsusb` to find device IDs, then add them here.
    users.users.yuxqiu.extraGroups = [ "usbguard" ];
    services.usbguard = {
      enable = true;
      rules = ''
        allow with-interface equals { 09:00:00 }
        allow id 27c6:659a    # Goodix fingerprint sensor
        allow id 04f2:b875    # Chicony integrated camera

        allow id 8087:0b40    # Intel USB3.0 Hub (office dock)
        allow id 0424:7206    # Microchip USB7206 Smart Hub (office dock)
        allow id 0424:7252    # Microchip USB7206 Smart Hub (office dock)
        allow id 0424:7216    # Microchip USB7216 Smart Hub (office dock)
        allow id 0bda:8156    # Realtek USB 10/100/1G/2.5G LAN (office dock)
        allow id 1d5c:5801    # Fresco Logic USB2.0 Hub (office dock)
        allow id 0bda:0409    # Realtek USB3.2 Hub (office dock)
        allow id 0bda:8153    # Realtek RTL8153 Gigabit Ethernet (office dock)
        allow id 0bda:5409    # Realtek USB2.1 Hub (office dock)
        allow id 0424:4206    # Microchip USB4206 Smart Hub, USB2.0 (office dock)
        allow id 0424:4252    # Microchip USB4206 Smart Hub, USB2.0 (office dock)
        allow id 0424:4216    # Microchip USB4216 Smart Hub, USB2.0 (office dock)
        allow id 0424:7260    # Microchip USB2 Controller Hub (office dock)
      '';
    };
  };
}
