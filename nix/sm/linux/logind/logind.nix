{ ... }:
{
  config = {
    environment = {
      etc = {
        # With mode, system-manager will copy the file to the destination.
        # It's important to specify file here as using folder still leads
        # to a symlink.
        "systemd/logind.conf.d/power.conf" = {
          source = ./logind.conf.d/power.conf;
          mode = "0644";
        };
      };
    };
  };
}
