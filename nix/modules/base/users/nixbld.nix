{
  # Fix: system-manager will remove nixbld{1-32} from nixbld members list if not set
  flake.modules.systemManager.nixbld =
    { pkgs, ... }:
    {
      users = {
        groups.nixbld = {
          gid = 30000;
          members = [ ]; # leave empty or don't set; userborn will populate from users
        };

        users = builtins.listToAttrs (
          map (
            n:
            let
              uid = 30000 + n;
              name = "nixbld${toString n}";
            in
            {
              name = name;
              value = {
                isSystemUser = true;
                group = "nixbld"; # primary group
                extraGroups = [ "nixbld" ]; # supplementary (important for getent/group membership)
                description = "Nix build user ${toString n}";
                home = "/var/empty";
                createHome = false;
                shell = pkgs.shadow;
                uid = uid;
              };
            }
          ) (builtins.genList (n: n + 1) 32) # create 32 users (or however many you want)
        );
      };
    };
}
