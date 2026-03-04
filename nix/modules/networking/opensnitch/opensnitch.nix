{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.opensnitch-ui ];

      # Add restart as opensnitch-ui is started too early and crashes consistently.
      services.opensnitch-ui.enable = true;
      systemd.user.services.opensnitch-ui = {
        Service = {
          Restart = "on-failure";
          RestartSec = "5";
        };
      };
    };

  flake.modules.systemManager.desktop =
    { nixosModulesPath, ... }:
    {
      imports = [ (nixosModulesPath + "/services/security/opensnitch.nix") ];

      services.opensnitch = {
        enable = true;
        settings = {
          Ebpf.ModulesPath = null;
        };
      };
    };
}
