{
  inputs,
  ...
}:
{
  flake.modules.homeManager.linux-base =
    { lib, config, ... }:
    {
      # Add dms toggle for t2p
      config = lib.mkIf config.my.sops.enable {
        programs.dank-material-shell.plugins.dankActions.settings = {
          variants = [
            {
              icon = "vpn_lock";
              displayText = "";
              displayCommand = "t2p status";
              clickCommand = "pkexec t2p toggle";
              middleClickCommand = "";
              rightClickCommand = "true";
              updateInterval = 0;
              showIcon = true;
              showText = true;
              id = "variant_1762019076882";
              name = "t2p";
              visibilityCommand = "";
              visibilityInterval = 0;
            }
          ];
        };
      };
    };

  flake.modules.systemManager.base =
    {
      lib,
      pkgs,
      config,
      ...
    }:
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

          REAL_RESOLV="/etc/resolv.conf"
          BACKUP_RESOLV="/etc/resolv.conf.t2p.backup"

          is_mounted() {
              mountpoint -q "$REAL_RESOLV" 2>/dev/null
          }

          cleanup_mount() {
              if is_mounted; then
                  if umount "$REAL_RESOLV" 2>/dev/null; then
                      echo "Unmounted /etc/resolv.conf bind mount"
                  else
                      echo "Warning: Could not unmount $REAL_RESOLV" >&2
                  fi
              fi
          }

          # Backup /etc/resolv.conf (simple file copy)
          backup_resolv() {
              if [ -f "$REAL_RESOLV" ]; then
                  cp -f "$REAL_RESOLV" "$BACKUP_RESOLV" && echo "Backed up /etc/resolv.conf"
              else
                  echo "Warning: /etc/resolv.conf not found — nothing to backup" >&2
                  return 1
              fi
          }

          # Restore /etc/resolv.conf from backup
          restore_resolv() {
              if [ -f "$BACKUP_RESOLV" ]; then
                  cp -f "$BACKUP_RESOLV" "$REAL_RESOLV" && chmod 644 "$REAL_RESOLV" && echo "Restored /etc/resolv.conf"
                  rm -f "$BACKUP_RESOLV"
              else
                  echo "No backup found — leaving /etc/resolv.conf unchanged" >&2
                  return 1
              fi
          }

          extract_bypass_ip() {
              if [[ ! -f "$CONFIG_PATH" ]]; then
                  echo "ERROR: Config not found: $CONFIG_PATH" >&2
                  exit 1
              fi

              DOMAIN=$(jq -r '
                  .outbounds[]
                  | select(.protocol == "vless" and (.settings.address // empty) != "")
                  | .settings.address
              ' "$CONFIG_PATH" | head -n 1)

              if [[ -z "$DOMAIN" || "$DOMAIN" == "null" ]]; then
                  echo "ERROR: No vless outbound with address found" >&2
                  exit 1
              fi

              BYPASS_IP=$(jq -r --arg domain "$DOMAIN" '
                  .dns?.hosts?[$domain] // empty
              ' "$CONFIG_PATH")

              if [[ -z "$BYPASS_IP" || "$BYPASS_IP" == "null" ]]; then
                  echo "ERROR: No IP found for domain '$DOMAIN' in dns.hosts" >&2
                  exit 1
              fi

              echo "$BYPASS_IP"
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

              CONFIG_PATH="${config.sops.secrets."xray.json".path}"

              BYPASS_IP=$(extract_bypass_ip)
              echo "Using bypass IP: $BYPASS_IP" >&2

              # Clean previous state
              cleanup

              # Launch
              echo "Launching tun2proxy..."
              $TUN2PROXY_BIN --setup --proxy socks5://127.0.0.1:1080 \
                  --dns virtual --virtual-dns-pool 198.18.0.0/15 \
                  --bypass "$BYPASS_IP" --daemonize &

              echo "Finish launching"

              # Wait until bind mount appears (or timeout)
              local timeout=12 elapsed=0
              while (( elapsed < timeout )); do
                  if is_mounted; then
                      echo "Success: /etc/resolv.conf is now bind-mounted by tun2proxy"

                      local captured_dns
                      captured_dns=$(cat "$REAL_RESOLV") || {
                          echo "ERROR: Could not read mounted /etc/resolv.conf" >&2
                          cleanup_mount
                          exit 1
                      }

                      cleanup_mount

                      backup_resolv

                      printf '%s' "$captured_dns" > "$REAL_RESOLV"
                      echo "Applied tunnel DNS settings to /etc/resolv.conf"

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
              restore_resolv
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
      config = lib.mkIf config.my.sops.enable {
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
    };
}
