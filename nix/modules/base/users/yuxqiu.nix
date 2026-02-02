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

  flake.modules.systemManager.yuxqiu =
    { pkgs, ... }:
    {
      users.users.yuxqiu = {
        isNormalUser = true;
        description = "yuxqiu";
        extraGroups = [
          "wheel"
          "input"
        ];
        initialPassword = "changeme";

        # it's fine to ignore shell program check as /etc/shells
        # management is done by self-hosted shells.nix
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };
    };
}
