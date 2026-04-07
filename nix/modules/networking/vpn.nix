{
  inputs,
  ...
}:
{
  flake.modules.homeManager.linux-base =
    {
      lib,
      config,
      pkgs,
      ...
    }:
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

        home.packages = with pkgs; [ proton-vpn ];
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
          gawk
          gnused
          procps # pgrep, pkill
          jq
          systemd
        ];

        text = ''
          set -euo pipefail

          PROG="tun2proxy-bin"
          TUN2PROXY_BIN="${tun2proxy}/bin/tun2proxy-bin"

          TUN_IF="tun0"

          REAL_RESOLV="/etc/resolv.conf"
          DOMAIN_CONF="/etc/systemd/resolved.conf.d/domain.conf"

          apply_resolved_dns() {
              local dns_list="$1"
              if [[ -z "$dns_list" ]]; then
                  echo "ERROR: Empty DNS list for systemd-resolved" >&2
                  return 1
              fi
              resolvectl dns "$TUN_IF" "$dns_list"
              resolvectl domain "$TUN_IF" "~."
              resolvectl flush-caches >/dev/null 2>&1 || true
              echo "Applied DNS via systemd-resolved for $TUN_IF: $dns_list"
          }

          reset_resolved_dns() {
              resolvectl revert "$TUN_IF" >/dev/null 2>&1 || true
              resolvectl flush-caches >/dev/null 2>&1 || true
              echo "Reverted DNS via systemd-resolved for $TUN_IF"
          }

          disable_global_domain_override() {
              if [[ -f "$DOMAIN_CONF" ]]; then
                  rm -f "$DOMAIN_CONF"
                  echo "Removed $DOMAIN_CONF to allow per-link DNS to take precedence"
              fi
              systemctl restart systemd-resolved
          }

          restore_global_domain_override() {
              systemctl restart systemd-resolved-domain-conf
              if [[ -f "$DOMAIN_CONF" ]]; then
                  echo "Restored $DOMAIN_CONF to force global DNS precedence"
              else
                  echo "Warning: $DOMAIN_CONF not restored" >&2
              fi
              systemctl restart systemd-resolved
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
              if ip link show "$TUN_IF" >/dev/null 2>&1; then
                  ip link del "$TUN_IF" 2>/dev/null && echo "$TUN_IF removed" || echo "failed to remove $TUN_IF"
              else
                  echo "$TUN_IF already gone"
              fi
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
                  --dns virtual --virtual-dns-pool 198.18.0.0/16 \
                  --bypass "$BYPASS_IP" --daemonize &

              echo "Finish launching"

              # Wait until bind mount appears (or timeout)
              local timeout=12 elapsed=0
              while (( elapsed < timeout )); do
                  if mountpoint -q "$REAL_RESOLV" 2>/dev/null; then
                      echo "Success: /etc/resolv.conf is now bind-mounted by tun2proxy"

                      local captured_dns
                      captured_dns=$(cat "$REAL_RESOLV") || {
                          echo "ERROR: Could not read mounted /etc/resolv.conf" >&2
                          umount "$REAL_RESOLV" 2>/dev/null || true
                          exit 1
                      }

                      umount "$REAL_RESOLV" 2>/dev/null || true

                      local dns_list
                      dns_list=$(printf '%s\n' "$captured_dns" | awk '/^nameserver[ \t]+/ {print $2; exit}')

                      disable_global_domain_override
                      apply_resolved_dns "$dns_list"

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
              reset_resolved_dns
              restore_global_domain_override
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
          restartUnits = [ "xray.service" ];
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
