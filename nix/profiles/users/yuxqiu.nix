{ config, ... }:
{
  flake.meta.yuxqiu = {
    dotfiles = ".dotfiles";
    keys = {
      githubPub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ppGOXp373SKeaGMKSfhQVVfvGIgpXXXcnnLDQ14hT yuxqiu@proton.me";
    };
  };

  flake.modules.homeManager.yuxqiu = hmArgs: {
    my.user = {
      dotfiles = "${hmArgs.config.home.homeDirectory}/${config.flake.meta.yuxqiu.dotfiles}";
      keys = config.flake.meta.yuxqiu.keys;
    };
  };

  flake.modules.systemManager.yuxqiu =
    { pkgs, ... }:
    {
      sops = {
        defaultSopsFile = ../secrets/yuxqiu.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        age.generateKey = true;
      };

      users.users.yuxqiu = {
        isNormalUser = true;
        description = "yuxqiu";
        extraGroups = [
          "wheel"
          "input"
          "docker"
          "i2c"
        ];
        initialPassword = "changeme";

        # it's fine to ignore shell program check as /etc/shells
        # management is done by self-hosted shells.nix
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };

      # dms-greeter uses its theme from a user's dir so we need
      # to specify that user.
      programs.dank-material-shell.greeter = {
        enable = true;
        configHome = "/home/yuxqiu";
      };
    };
}
