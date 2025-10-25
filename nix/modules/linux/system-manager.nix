{ pkgs, system, ... }:
let
  policy-file = pkgs.writeText "allow-system-manager.te" ''
    module allow-system-manager 1.0;
    require {
            type default_t;
            type tmpfs_t;
            type ifconfig_t;
            type init_t;
            type systemd_unit_file_t;
            class cap_userns net_admin;
            class lnk_file read;
            class file { execute execute_no_trans map open read };
    }
    #============= ifconfig_t ==============
    allow ifconfig_t self:cap_userns net_admin;
    allow ifconfig_t tmpfs_t:lnk_file read;
    #============= init_t ==============
    allow init_t default_t:file map;
    allow init_t default_t:file { execute execute_no_trans open read };
    allow init_t default_t:lnk_file read;
    # Allow systemd to read systemd unit files with default_t context
    allow init_t default_t:file read;
  '';

  policy-package = pkgs.runCommand "allow-system-manager.pp" {
    buildInputs = with pkgs; [ policycoreutils checkpolicy semodule-utils ];
  } ''
    checkmodule -M -m -o allow-system-manager.mod ${policy-file}
    semodule_package -o $out -m allow-system-manager.mod
  '';
in {
  imports = [
    ./dnscrypt-proxy/dnscrypt-proxy.nix
    ./earlyoom.nix
    ./logind/logind.nix
    ./journald/journald.nix
    ./NetworkManager/NetworkManager.nix
    ./autorestic.nix
    ./howdy/howdy.nix
  ];

  nix = { enable = false; };

  system-manager.allowAnyDistro = true;
  nixpkgs.hostPlatform = system;

  # https://github.com/numtide/system-manager/issues/115
  system-manager.preActivationAssertions.install-selinux-policy = {
    enable = true;
    script = ''
      # Check for system-wide SELinux tools first, then fall back to Nix
      GETENFORCE=$(command -v getenforce || echo ${pkgs.libselinux}/bin/getenforce)
      SEMODULE=$(command -v semodule || echo ${pkgs.policycoreutils}/bin/semodule)
      RESTORECON=$(command -v restorecon || echo ${pkgs.policycoreutils}/bin/restorecon)

      # Check if SELinux is installed and enabled
      if command -v "$GETENFORCE" >/dev/null 2>&1; then
        SELINUX_MODE=$("$GETENFORCE" 2>/dev/null)
        if [ "$SELINUX_MODE" = "Enforcing" ] || [ "$SELINUX_MODE" = "Permissive" ]; then
          echo "SELinux is enabled ($SELINUX_MODE). Installing policy..."
          set -e
          # Remove old module if exists
          "$SEMODULE" -r allow-system-manager 2>/dev/null || true
          # Install pre-built policy package
          "$SEMODULE" -i ${policy-package}
          # Fix contexts and reload
          "$RESTORECON" -R /etc/systemd/system/
          systemctl daemon-reload
          echo "SELinux policy installed"
        else
          echo "SELinux is disabled. Skipping policy installation."
        fi
      else
        echo "SELinux tools not found. Skipping policy installation."
      fi
    '';
  };
}
