{
  flake.modules.homeManager.linux-desktop = {
    # enable xdg
    xdg.enable = true;

    # let hm to manage xdg user dirs
    xdg.userDirs.enable = true;

    xdg.autostart.enable = true;
    xdg.mime.enable = true;
    xdg.portal.enable = true;
    xdg.terminal-exec.enable = true;
  };
}
