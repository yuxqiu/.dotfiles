{ ... }:
{
  flake.modules.homeManager.yuxqiu =
    { config, ... }:
    {
      my.user = {
        dotfiles = "${config.home.homeDirectory}/.dotfiles";
        keys = {
          githubPub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ppGOXp373SKeaGMKSfhQVVfvGIgpXXXcnnLDQ14hT yuxqiu@proton.me";
        };
      };
    };

  flake.modules.systemManager.yuxqiu =
    { pkgs, ... }:
    {
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
    };
}
