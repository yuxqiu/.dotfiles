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
in {
  config = {
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
      description =
        "Watch for fprintd segfaults or Goodix 2541:0236 re-plug and restart it";
      after = [ "network.target" "fprintd.service" ];
      wants = [ "fprintd.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment =
          "PATH=/run/system-manager/sw/bin/:/home/${username}/.local/bin:/home/${username}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin";
        ExecStart = "${watchFprintd}/bin/watch-fprintd.sh";
        Restart = "always";
        RestartSec = 10;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
