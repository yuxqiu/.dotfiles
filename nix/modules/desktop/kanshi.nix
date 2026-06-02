{ ... }:
{
  flake.modules.homeManager.kanshi = {
    services.kanshi = {
      enable = true;

      settings = [
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL U2723QE";
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
