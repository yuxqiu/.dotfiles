{ pkgs, ... }:
{
  programs.zsh = {
    shellAliases = {
      # Docker
      dockup = "systemctl start docker";
      dockdown = "systemctl stop docker.socket";

      # Open
      open = "xdg-open";

      system-manager-update = "nix flake update && system-manager switch --flake .#${pkgs.stdenv.system} --sudo && rm result";
    };

    siteFunctions = {
      gc-dnf = ''
        sudo dnf autoremove
        sudo dnf clean all
      '';
      gc-sm = ''
        sudo $(which nix-env) --delete-generations old --profile /nix/var/nix/profiles/system-manager-profiles/system-manager
        gc-nix
      '';
    };
  };

  # oh-my-zsh clipboard plugin dependencies
  home.packages = [ pkgs.wl-clipboard ];
}
