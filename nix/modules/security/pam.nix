{
  flake.modules.systemManager.base =
    { pkgs, ... }:
    {
      # One-time setup for PAM unix_chkpwd helper on non-NixOS distributions.
      # Creates the expected setuid wrapper location /run/wrappers/bin/unix_chkpwd if missing.
      #
      # https://github.com/nix-community/home-manager/issues/7027
      systemd.services.create-unix-chkpwd-symlink = {
        description = "Create /run/wrappers/bin/unix_chkpwd symlink (one-time setup for PAM on non-NixOS)";
        wantedBy = [ "system-manager.target" ]; # Runs during system-manager activation
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          set -euo pipefail

          # Find the real unix_chkpwd reliably across distros (often in /usr/sbin or /sbin)
          HELPER="$(${pkgs.findutils}/bin/find /usr/sbin /sbin /usr/bin \
            -type f -name unix_chkpwd -perm /4000 2>/dev/null | head -n1)"

          if [[ -z "$HELPER" ]]; then
            echo "ERROR: unix_chkpwd not found in common locations" >&2
            exit 1
          fi

          if [[ -e /run/wrappers/bin/unix_chkpwd ]]; then
            echo "Symlink already exists at /run/wrappers/bin/unix_chkpwd"
            exit 0
          fi

          echo "Found unix_chkpwd at: $HELPER"
          echo "Creating directory and symlink..."

          mkdir -p /run/wrappers/bin
          ln -sf "$HELPER" /run/wrappers/bin/unix_chkpwd

          echo "Symlink created successfully"
        '';
      };
    };
}
