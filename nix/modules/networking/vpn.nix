{
  inputs,
  ...
}:
{
  flake.modules.systemManager.base =
    { pkgs, config, ... }:
    let
      tun2proxy = inputs.tun2proxy.packages.${pkgs.stdenv.hostPlatform.system}.default;

      t2p = pkgs.writeShellApplication {
        name = "t2p";

        runtimeInputs = with pkgs; [
          iproute2
          util-linux # mountpoint
          coreutils
          procps # pgrep, pkill
          jq
        ];

        text = ''
          set -euo pipefail

          PROG="tun2proxy-bin"
          TUN2PROXY_BIN="${tun2proxy}/bin/tun2proxy-bin"
          CONFIG_PATH="${config.sops.secrets."xray.json".path}"

          # ────────────────────────────────────────────────
          # Extract BYPASS_IP from xray config at runtime
          # ────────────────────────────────────────────────
          if [[ ! -f "$CONFIG_PATH" ]]; then
              echo "ERROR: Xray config not found at $CONFIG_PATH" >&2
              exit 1
          fi

          # Find first vless outbound's address (domain)
          DOMAIN=$(jq -r '
              .outbounds[]
              | select(.settings.address)
              | .settings.address
              | select(.)' "$CONFIG_PATH" | head -n 1)

          if [[ -z "$DOMAIN" || "$DOMAIN" == "null" ]]; then
              echo "ERROR: No VLESS outbound with 'address' field found in $CONFIG_PATH" >&2
              exit 1
          fi

          # Lookup that domain in dns.hosts
          BYPASS_IP=$(jq -r --arg domain "$DOMAIN" '
              .dns.hosts[$domain] // empty
          ' "$CONFIG_PATH")

          if [[ -z "$BYPASS_IP" || "$BYPASS_IP" == "null" ]]; then
              echo "ERROR: No IP found in dns.hosts for domain '$DOMAIN' in $CONFIG_PATH" >&2
              echo "       Expected something like: \"dns\": {\"hosts\": {\"$DOMAIN\": \"1.2.3.4\"}}" >&2
              exit 1
          fi

          echo "Using bypass IP: $BYPASS_IP (for domain $DOMAIN)" >&2

          REAL_RESOLV="/etc/resolv.conf"

          is_mounted() {
              mountpoint -q "$REAL_RESOLV" 2>/dev/null
          }

          cleanup_mount() {
              if is_mounted; then
                  if umount "$REAL_RESOLV" 2>/dev/null; then
                      echo "Unmounted stale /etc/resolv.conf bind mount"
                  else
                      echo "Warning: Could not unmount $REAL_RESOLV" >&2
                  fi
              fi
          }

          status() {
              if pgrep -x "$PROG" >/dev/null; then
                  echo "on"
              else
                  echo "off"
              fi
          }

          cleanup() {
              if ip link show tun0 >/dev/null 2>&1; then
                  ip link del tun0 2>/dev/null && echo "tun0 removed" || echo "failed to remove tun0"
              else
                  echo "tun0 already gone"
              fi
              cleanup_mount
          }

          start() {
              echo "starting..."

              # Clean previous state
              cleanup

              # Launch
              $TUN2PROXY_BIN --setup --proxy socks5://127.0.0.1:1080 \
                  --dns virtual --virtual-dns-pool 198.18.0.0/15 \
                  --bypass "$BYPASS_IP" --daemonize &
              echo "Finish launching"

              # Wait until bind mount appears (or timeout)
              local timeout=12 elapsed=0
              while (( elapsed < timeout )); do
                  echo "Here"
                  if is_mounted; then
                      echo "Success: /etc/resolv.conf is now bind-mounted by tun2proxy"
                      return 0
                  fi
                  sleep 0.3
                  (( elapsed += 1 ))
                  if (( elapsed % 5 == 0 )); then
                      echo "Waiting for bind mount... ($elapsed/$timeout s)"
                  fi
              done

              echo "ERROR: bind mount did not appear after $timeout seconds" >&2
              cleanup
              exit 1
          }

          stop() {
              echo "stopping..."

              if pgrep -x "$PROG" >/dev/null; then
                  pkill -TERM "$PROG" 2>/dev/null
                  sleep 1.5   # give it time to exit and clean up mount
                  if pgrep -x "$PROG" >/dev/null; then
                      pkill -9 "$PROG" && echo "forced kill"
                  else
                      echo "gracefully stopped"
                  fi
              else
                  echo "not running"
              fi

              # Final cleanup – should be gone by now, but force if needed
              sleep 0.5
              cleanup
          }

          toggle() {
              if pgrep -x "$PROG" >/dev/null; then
                  stop
              else
                  start
              fi
          }

          case "''${1:-}" in
            toggle) toggle ;;
            status) status ;;
            *) echo "Usage: $(basename "$0") {toggle|status}" >&2; exit 1 ;;
          esac
        '';
      };
    in
    {
      users.groups.xray = { };
      users.users.xray = {
        isSystemUser = true;
        group = "xray";
        home = "/var/lib/xray";
        createHome = true;
        description = "Xray daemon user";
      };

      sops.secrets."xray.json" = {
        mode = "0400";
        owner = config.users.users.xray.name;
        group = config.users.users.xray.group;
      };

      systemd.services.xray = {
        description = "Xray Proxy Server";

        after = [
          "network-online.target"
        ];
        wants = [ "network-online.target" ];

        unitConfig = {
          ConditionPathExists = config.sops.secrets."xray.json".path;
        };

        serviceConfig = {
          Type = "exec";
          ExecStart = "${pkgs.xray}/bin/xray run -c ${config.sops.secrets."xray.json".path}";
          User = "xray";
          Group = "xray";
          DynamicUser = false;
        };
      };

      environment.systemPackages = [ t2p ];
    };
}
