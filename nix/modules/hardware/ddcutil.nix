{
  flake.modules.systemManager.base = {
    # https://www.ddcutil.com/i2c_permissions_using_group_i2c/
    environment = {
      etc = {
        "udev/rules.d/60-ddcutil-i2c.rules" = {
          text = ''
            KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
          '';
          mode = "0644";
          replaceExisting = true;
        };
      };
    };

    boot.kernelModules = [ "i2c-dev" ];

    users.groups.i2c = { };
  };
}
