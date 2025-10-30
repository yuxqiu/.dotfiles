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

    siteFunctions = {
      proxy = ''
        socks_proxy="socks5://127.0.0.1:1080"

        if [[ -z "$1" ]]; then
            echo "Usage: proxy <command> [args...]"
            return 1
        fi

        env \
            all_proxy="$socks_proxy" \
            ALL_PROXY="$socks_proxy" \
            socks_proxy="$socks_proxy" \
            SOCKS_PROXY="$socks_proxy" \
            zsh -c "$*"
      '';
    };
  };
}
