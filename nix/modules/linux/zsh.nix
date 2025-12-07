{ pkgs, ... }: {
  programs.zsh = {
    shellAliases = {
      # Docker
      dockup = "systemctl start docker";
      dockdown = "systemctl stop docker.socket";

      # Open
      open = "xdg-open";

      system-manager-update =
        "nix flake update && sudo $(which system-manager) switch --flake .#${pkgs.stdenv.system} && rm result";
    };
  };
}
