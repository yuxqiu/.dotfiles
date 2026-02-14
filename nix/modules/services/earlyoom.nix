{
  flake.modules.systemManager.base =
    { pkgs, ... }:
    let
      EARLYOOM_ARGS = "-n -r 0 -m 10 --prefer '^(Web Content|Isolated Web Co)$' --avoid '^(greetd|systemd|systemd-logind|dbus-daemon|dbus-broker|niri)$'";
    in
    {
      systemd.maskedUnits = [
        "systemd-oomd.service"
      ];

      # from dnf
      systemd.services.earlyoom = {
        description = "Early OOM Daemon";
        documentation = [
          "man:earlyoom(1)"
          "https://github.com/rfjakob/earlyoom"
        ];

        wantedBy = [ "multi-user.target" ];
        wants = [ "basic.target" ];
        after = [ "basic.target" ];

        serviceConfig = {
          # Use the exact binary from the Nix store
          ExecStart = "${pkgs.earlyoom}/bin/earlyoom ${EARLYOOM_ARGS}";

          # Load optional user overrides
          EnvironmentFile = "-/etc/default/earlyoom";

          # Capabilities
          AmbientCapabilities = [
            "CAP_KILL"
            "CAP_IPC_LOCK"
          ];
          CapabilityBoundingSet = [
            "CAP_KILL"
            "CAP_IPC_LOCK"
          ];

          # Scheduling priority
          Nice = -20;
          OOMScoreAdjust = -100;

          # Restart if it ever dies
          Restart = "always";

          # Resource limits
          TasksMax = 10;
          MemoryMax = "50M";

          # === Hardening (exactly as in your unit) ===
          DynamicUser = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          LockPersonality = true;

          # Isolate network completely (earlyoom doesn't need it)
          PrivateNetwork = true;
          IPAddressDeny = "any";

          # Only allow AF_UNIX (needed for status via earlyoom -s or dbus-send)
          RestrictAddressFamilies = [ "AF_UNIX" ];

          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "process_mrelease"
            "~@privileged"
          ];
        };
      };
    };
}
