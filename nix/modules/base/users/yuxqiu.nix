{ config, ... }:
{
  flake.meta.yuxqiu = {
    dotfiles = ".dotfiles";
    keys = {
      githubPub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ppGOXp373SKeaGMKSfhQVVfvGIgpXXXcnnLDQ14hT yuxqiu@proton.me";
    };
  };

  flake.modules.homeManager.yuxqiu = hmArgs: {
    config.user = {
      dotfiles = "${hmArgs.config.home.homeDirectory}/${config.flake.meta.yuxqiu.dotfiles}";
      keys = config.flake.meta.yuxqiu.keys;
    };
  };

  flake.modules.systemManager.yuxqiu = {
    users.users.yuxqiu = {
      isNormalUser = true;
      description = "yuxqiu User";
      extraGroups = [
        "wheel"
        "input"
      ];
      initialPassword = "changeme";

      # It's not possible to manage shell yet as there is a
      # shell program check employed that enforces we set
      # programs.zsh.enable = true;
      #
      # Even though this can be skipped and the shell will be
      # correctly set, it will render some components that
      # rely on /etc/shells unusable.
      # - /etc/shells is a file that contains the full path of
      #   the valid login shell. Managing it solely by ourselves
      #   is too error-prone. Thus, shell is left unmanaged for now.
      #
      shell = "/bin/zsh"; # ideally, should be set to pkgs.zsh
    };
  };

  # Fix: system-manager will remove nixbld{1-32} from nixbld members list if not set
  flake.modules.systemManager.nix =
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
