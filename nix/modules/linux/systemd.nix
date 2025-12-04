{ ... }: {
  # allow systemd to discover user service files installed by nix
  # - https://unix.stackexchange.com/a/696035
  xdg.configFile."systemd/user.conf".text = ''
    [Manager]
    ManagerEnvironment="XDG_DATA_DIRS=/home/yuxqiu/.nix-profile/share:/nix/var/nix/profiles/default/share"
  '';
}
