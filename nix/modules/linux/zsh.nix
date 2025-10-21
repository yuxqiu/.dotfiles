{ system, ... }: {
  programs.zsh = {
    shellAliases = {
      # Docker
      dockup = "systemctl start docker";
      dockdown = "systemctl stop docker.socket";

      # Open
      open = "xdg-open";

      # Mount iPhone and Perform backup
      backup-ios =
        "mkdir -p ~/iPhone && sudo ifuse ~/iPhone && sudo autorestic backup -l ios";

      system-manager-update =
        "nix flake update && sudo $(which nix) run 'github:numtide/system-manager' -- switch --flake .#${system} && rm result";
    };
  };
}
