{ ... }:
{
  config = {
    environment = {
      etc = {
        "NetworkManager/conf.d/connectivity.conf" = {
          source = ./conf.d/connectivity.conf;
          mode = "0644";
        };
        "NetworkManager/conf.d/dns-servers.conf" = {
          source = ./conf.d/dns-servers.conf;
          mode = "0644";
        };
        "NetworkManager/conf.d/hostname.conf" = {
          source = ./conf.d/hostname.conf;
          mode = "0644";
        };
        "NetworkManager/conf.d/wifi_rand_mac.conf" = {
          source = ./conf.d/wifi_rand_mac.conf;
          mode = "0644";
        };
      };
    };

    # TODO: put in activation script
    system-manager.preActivationAssertions.disable-systemd-resolved = {
      enable = true;
      script = ''
        # Disable and stop systemd-resolved only if it is currently enabled/active
        if systemctl is-active --quiet systemd-resolved; then
          echo "Disabling 'systemd-resolved'"
          systemctl disable --now systemd-resolved
        else
          echo "Skipped because systemd-resolved is already disabled."
        fi
      '';
    };
  };
}
