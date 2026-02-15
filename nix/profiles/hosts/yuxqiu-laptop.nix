{
  config,
  ...
}:

{
  configurations.homeManager = {
    "yuxqiu-laptop" = {
      system = "aarch64-linux";
      stateVersion = "26.05";
      modules = [
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.desktop
        config.flake.modules.homeManager.linux-base
        config.flake.modules.homeManager.linux-desktop

        config.flake.modules.homeManager.yuxqiu
        config.flake.modules.homeManager.yuxqiu-laptop
      ];
    };
  };

  configurations.systemManager = {
    "yuxqiu-laptop" = {
      system = "aarch64-linux";
      modules = [
        config.flake.modules.systemManager.base
        config.flake.modules.systemManager.desktop

        config.flake.modules.systemManager.yuxqiu
        config.flake.modules.systemManager.yuxqiu-laptop
      ];
    };
  };

  flake.modules.homeManager.yuxqiu-laptop = {
    my.sops.enable = true;
  };

  flake.modules.systemManager.yuxqiu-laptop =
    { config, ... }:
    {
      my.sops.enable = true;
      sops = {
        defaultSopsFile = ../secrets/yuxqiu.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        age.generateKey = true;
      };

      # dms-greeter uses its theme from a user's dir so we need
      # to specify that user.
      programs.dank-material-shell.greeter = {
        enable = true;
        configHome = config.users.users.yuxqiu.home;
      };
    };
}
