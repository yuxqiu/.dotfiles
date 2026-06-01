{
  flake.modules.systemManager.NetworkManager = {
    environment = {
      etc = {
        "NetworkManager/conf.d/connectivity.conf" = {
          source = ./conf.d/connectivity.conf;
          mode = "0644";
          replaceExisting = true;
        };
        "NetworkManager/conf.d/hostname.conf" = {
          source = ./conf.d/hostname.conf;
          mode = "0644";
          replaceExisting = true;
        };
        "NetworkManager/conf.d/wifi_rand_mac.conf" = {
          source = ./conf.d/wifi_rand_mac.conf;
          mode = "0644";
          replaceExisting = true;
        };
      };
    };
  };

  flake.modules.nixos.NetworkManager = {
    networking.networkmanager = {
      enable = true;
      wifi.macAddress = "random";
      ethernet.macAddress = "random";
    };

    environment.etc = {
      "NetworkManager/conf.d/connectivity.conf" = {
        source = ./conf.d/connectivity.conf;
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
}
