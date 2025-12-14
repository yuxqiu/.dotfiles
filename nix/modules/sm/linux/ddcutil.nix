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

    system-manager.preActivationAssertions.add-i2c-group = {
      enable = true;
      script = ''
        if ! id "$USER" | grep -q '\bi2c\b'; then
          # Create system group 'i2c' if it doesn't exist
          if ! getent group i2c > /dev/null; then
            echo "Creating 'i2c' group"
            groupadd --system i2c
          fi

          # Add the activating user to group 'i2c' if not already a member
          echo "Adding user to the 'i2c' group"
          usermod -aG i2c "$USER"
        else
          echo "Skipped because user is already in i2c group."
        fi
      '';
    };
  };
}
