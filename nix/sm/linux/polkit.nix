{ pkgs, ... }:

{
  # Essential setup for Polkit integration in Nix apps on non-NixOS distributions.
  # Creates the expected setuid wrapper location for polkit-agent-helper-1 if missing or broken.
  systemd.services.create-polkit-helper-symlink = {
    description = "Create /run/wrappers/bin/polkit-agent-helper-1 symlink (one-time setup for Polkit on non-NixOS)";
    wantedBy = [ "system-manager.target" ]; # Runs during system-manager activation
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -euo pipefail

      # Find the real polkit-agent-helper-1 reliably across distros
      HELPER="$(${pkgs.findutils}/bin/find /usr/lib /usr/libexec /usr/lib64 \
        -type f -name polkit-agent-helper-1 -perm /4000 2>/dev/null | head -n1)"

      if [[ -z "$HELPER" ]]; then
        echo "ERROR: polkit-agent-helper-1 not found in common locations" >&2
        exit 1
      fi

      if [[ -e /run/wrappers/bin/polkit-agent-helper-1 ]]; then
        echo "Symlink already exists at /run/wrappers/bin/polkit-agent-helper-1"
        exit 0
      fi

      echo "Found polkit-agent-helper-1 at: $HELPER"
      echo "Creating directory and symlink..."

      mkdir -p /run/wrappers/bin
      ln -sf "$HELPER" /run/wrappers/bin/polkit-agent-helper-1

      echo "Symlink created successfully"
    '';
  };
}
