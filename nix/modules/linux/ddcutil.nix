{ ... }: {
  # https://www.ddcutil.com/i2c_permissions_using_group_i2c/
  config = {
    environment = {
      etc = {
        "udev/rules.d/60-ddcutil-i2c.rules" = {
          text = ''
            KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
          '';
          mode = "0644";
        };

        # load i2c module via systemd-modules-load service
        "modules-load.d/01-i2c-dev.conf" = {
          text = "i2c-dev";
          mode = "0644";
        };
      };
    };
  };
}
