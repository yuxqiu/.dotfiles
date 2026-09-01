{
  flake.modules.nixos.yuxqiu-cedrus =
    { config, ... }:
    {
      programs.dms-greeter.configHome = config.users.users.yuxqiu.home;
    };
}
