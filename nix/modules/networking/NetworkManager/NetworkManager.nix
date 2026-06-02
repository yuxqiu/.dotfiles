{
  flake.modules.nixos.NetworkManager = {
    networking.networkmanager = {
      enable = true;
      wifi.macAddress = "random";
      ethernet.macAddress = "random";

      settings = {
        connectivity.enabled = false;

        "device-mac-randomization"."wifi.scan-rand-mac-address" = true;
      };

      connectionConfig = {
        "ipv4.dhcp-send-hostname" = false;
        "ipv6.dhcp-send-hostname" = false;
      };
    };

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
