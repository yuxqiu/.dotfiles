{ ... }: {
  # enable xdg (xdg-mime is default enabled)
  xdg.enable = true;
  xdg.autostart.enable = true;
  xdg.mime.enable = true;

  # let hm to manage xdg user dirs
  xdg.userDirs.enable = true;
}
