{
  flake.modules.systemManager.base =
    { config, lib, ... }:
    {
      users.users = lib.mkMerge (
        map (name: {
          ${name} = {
            extraGroups = lib.mkAfter config.my.users.defaultExtraGroups;
          };
        }) config.my.users.normalUsers
      );
    };
}
