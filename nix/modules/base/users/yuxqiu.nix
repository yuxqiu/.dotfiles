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
        description = "yuxqiu User";
        extraGroups = [
          "wheel"
          "input"
        ];
        initialPassword = "changeme";

        # It's fine to skip shell program check on non-nixos + system-manager
        # as we do not rely on nix path to login.
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };
    };
}
