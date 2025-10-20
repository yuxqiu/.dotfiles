{ ... }: {
  programs.zsh = {
    shellAliases = {
      # Docker
      dockup = "systemctl start docker";
      dockdown = "systemctl stop docker.socket";

      # Open
      open="xdg-open";

      backup-ios="mkdir -p ~/iPhone && sudo ifuse ~/iPhone && sudo autorestic backup -l ios";
    };
  };
}
