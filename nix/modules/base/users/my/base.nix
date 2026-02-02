{ lib, ... }:
{
  flake.modules.homeManager.base = {
    options.my.user = {
      dotfiles = lib.mkOption {
        type = lib.types.path;
        apply = toString;
        description = "Location of the dotfiles working copy";
      };

      keys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Personal public keys";
      };
    };
  };

  # for better multi-user systems setup
  flake.modules.systemManager.base = {
    options.my.users = {
      normalUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "alice"
          "bob"
        ];
        description = "Usernames considered normal/human users";
      };

      defaultExtraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Groups automatically added to every normal user";
      };
    };
  };
}
