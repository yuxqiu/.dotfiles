{ ... }:
{
  flake.modules.homeManager.linux-desktop =
    { config, lib, ... }:
    lib.mkIf (config.my.kanshi.externalMonitorName != null) {
      services.kanshi = {
        enable = true;

        settings = [
          {
            profile.name = "home";
            profile.outputs = [
              {
                criteria = config.my.kanshi.externalMonitorName;
                position = "0,0";
                scale = 2.0;
              }
              {
                criteria = "eDP-1";
                status = "disable";
              }
            ];
          }
          {
            profile.name = "laptop";
            profile.outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.5;
              }
            ];
          }
        ];
      };
    };
}
