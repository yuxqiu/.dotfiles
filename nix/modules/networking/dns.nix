{
  flake.modules.nixos.dns =
    { pkgs, ... }:
    {
      services.resolved.enable = true;

      # create resolved domain config before resolved starts
      systemd.services.systemd-resolved-domain-conf = {
        enable = true;
        description = "Create global DNS domain override for systemd-resolved";
        before = [ "systemd-resolved.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "systemd-resolved-domain-setup" ''
            set -euo pipefail

            ${pkgs.coreutils}/bin/mkdir -p /etc/systemd/resolved.conf.d
            ${pkgs.coreutils}/bin/printf "[Resolve]\\nDomains=~.\\n" > /etc/systemd/resolved.conf.d/domain.conf
          '';
          StandardOutput = "journal";
        };
      };

      services.dnscrypt-proxy = {
        enable = true;
        settings = {
          server_names = [
            "odoh-squared"
            "odoh-cloudflare"
          ];
          listen_addresses = [ "127.0.0.1:53" ];
          sources."odoh-squared" = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/oh-no-odoh-servers/main/odoh-servers.md"
              "https://raw.githubusercontent.com/DNSCrypt/oh-no-odoh-servers/main/odoh-servers.md"
            ];
            minisign_key = "RWQf6LRCGA9i53mlYcJ+9XB0dUjo7Z2kZ2O4PN7z4bJY3Y+G+3XJHDUa";
            cache_file = "odoh-servers.md";
          };
          anonymized_dns.routes = [
            {
              server_name = "*";
              via = [
                "odoh-squared"
                "odoh-cloudflare"
              ];
            }
          ];
          dns_query = [
            {
              name = "*";
              type = "*";
            }
          ];
        };
      };

      networking.nameservers = [
        "127.0.0.1"
        "::1"
      ];

      services.resolved.settings.Resolve = {
        DNS = "127.0.0.1";
        FallbackDNS = "";
      };
    };
}
