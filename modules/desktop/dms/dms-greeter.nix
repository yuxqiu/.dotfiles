{
  inputs,
  ...
}:
{
  flake.modules.nixos.dms = {
    imports = [
      inputs.dank-greeter.nixosModules.default
    ];

    programs.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };

    users.groups.greeter = { };
    users.users.greeter = {
      isSystemUser = true;
      group = "greeter";
      home = "/var/lib/greeter";
      createHome = true;
      description = "Greetd default session user";
    };
  };
}
