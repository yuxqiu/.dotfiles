{ ... }: {
  programs.zsh = {
    shellAliases = {
      # Docker
      dockup = "systemctl start docker";
      dockdown = "systemctl stop docker.socket";

      # Open
      open="xdg-open";
    };
  };
}
