{ ... }: {
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

    # Ideally, this should be placed in an activation script
    # so that we can automatically restart NetworkManager.
    system-manager.preActivationAssertions.disable-systemd-resolved = {
      enable = true;
      script = ''
        # Disable and stop systemd-resolved only if it is currently enabled/active
        if systemctl is-active --quiet systemd-resolved; then
          systemctl disable --now systemd-resolved
        else
          echo "Skipped, systemd-resolved is already disabled."
        fi
      '';
    };
  };
}
