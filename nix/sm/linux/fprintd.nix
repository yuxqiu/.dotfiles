{ pkgs, username, ... }:

let
  watchFprintd = pkgs.writeShellScriptBin "watch-fprintd.sh" ''
    restart_fprintd() {
        echo "[fprintd-watchdog] Restarting fprintd due to segfault or device reinsertion..."
        systemctl kill fprintd || true
        sleep 1 # sleeping is always healthy
        systemctl restart fprintd
    }

    # Follow kernel messages
    journalctl -kf -t kernel --cursor-file="/var/tmp/fprintd-journal.cursor" | while read -r line; do
        if echo "$line" | grep -Eq "fprintd.*segfault|New USB.*found.*idVendor=2541.*idProduct=0236"; then
            restart_fprintd
        fi
    done
  '';
in
{
  environment = {
    etc = {
      # Rule is from:
      # - https://discussion.fedoraproject.org/t/fingerprint-instability-on-fedora-42-kde-thinkpad-x1-yoga-gen6/154101/2
      "udev/rules.d/01-disable-fingerprint-autosuspend.rules" = {
        text = ''
          ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2541", ATTRS{idProduct}=="0236", TEST=="power/control", ATTR{power/control}="on"
        '';
        mode = "0644";
      };
    };
  };

  # segfault
  # https://github.com/ddlsmurf/libfprint-CS9711/issues/4
  # - This fork may segfault when unlocking screens, which will make unlock with fprint unusable
  # - The temporary solution below can minimize the impact of the segfault.
  systemd.services.fprintd-watchdog = {
    description = "Watch for fprintd segfaults or Goodix 2541:0236 re-plug and restart it";
    after = [
      "network.target"
      "fprintd.service"
    ];
    wants = [ "fprintd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Environment = "PATH=/run/system-manager/sw/bin/:/home/${username}/.local/bin:/home/${username}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin";
      ExecStart = "${watchFprintd}/bin/watch-fprintd.sh";
      Restart = "always";
      RestartSec = 10;
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # TODO: put in activation script
  system-manager.preActivationAssertions.enable-fingerprint-auth = {
    enable = true;
    script = ''
      # Detect if this is Fedora
      if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ ! "$ID" == *"fedora"* ]]; then
          echo "Skipped because of unsupported system (not Fedora)"
          exit 0
        fi
      else
        echo "Skipped because of unsupported system (no /etc/os-release)"
        exit 0
      fi

      # Track if any change was made
      changed=0

      # Get current profile and features
      current=$(authselect current 2>/dev/null || echo "No authselect configuration")

      if [[ "$current" == "No authselect configuration" ]]; then
        echo "Skipped because no authselect configuration found"
        exit 0
      fi

      profile=$(echo "$current" | grep "Profile ID:" | awk '{print $3}')

      # If not using the 'local' profile, switch to it
      if [[ "$profile" != "local" ]]; then
        echo "Selecting 'local' profile"
        authselect select local --force
        changed=1
      fi

      # Check if with-fingerprint feature is already enabled
      if ! echo "$current" | grep -q "with-fingerprint"; then
        echo "Enabling with-fingerprint feature"
        authselect enable-feature with-fingerprint
        changed=1
      fi

      # Apply changes only if something was modified
      if [[ $changed -eq 1 ]]; then
        echo "Applying authselect changes"
        authselect apply-changes
      else
        echo "Skipped because fingerprint auth is already configured"
      fi
    '';
  };
}
