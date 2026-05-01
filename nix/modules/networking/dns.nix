{
  flake.modules.systemManager.base =
    {
      pkgs,
      lib,
      nixosModulesPath,
      ...
    }:
    let
      hasIPv6Internet = true;
      dnscrypt-resolvers = pkgs.fetchFromGitHub {
        owner = "DNSCrypt";
        repo = "dnscrypt-resolvers";
        rev = "cae8c6b858bd006c0dd193fd085f79e9bc70cd41"; # follow:branch master
        hash = "sha256-1aaAY3ds+/FEwPdho96+JJbF+WD9bIk6RMZeyYzKpDI=";
      };
    in
    {
      # Hack for importing dnscrypt-proxy from nixos
      options.networking.nameservers = lib.mkOption {
        type = lib.types.raw;
      };

      imports = [
        (nixosModulesPath + "/services/networking/dnscrypt-proxy.nix")
      ];

      config = {
        environment = {
          etc = {
            "systemd/resolved.conf.d/dnscrypt.conf" = {
              text = ''
                [Resolve]
                # Forward all queries to dnscrypt-proxy on port 53
                DNS=127.0.0.1:53

                # Strongly recommended: disable fallbacks so nothing bypasses dnscrypt-proxy
                FallbackDNS=

                # Disable resolved's own DoT/DoH (dnscrypt-proxy handles encryption)
                DNSOverTLS=no
                DNSSEC=no
              '';
            };
          };
        };

        # create resolved domain config before resolved starts
        systemd.services.systemd-resolved-domain-conf = {
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

        # https://www.reddit.com/r/NixOS/comments/1pvq42f/nixos_dnscryptproxy_with_odoh_relays_servers_oisd/
        services.dnscrypt-proxy = {
          enable = true;
          settings = {
            sources.public-resolvers = {
              cache_file = "${dnscrypt-resolvers}/v3/public-resolvers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };

            sources.relays = {
              cache_file = "${dnscrypt-resolvers}/v3/relays.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };

            sources.odoh-servers = {
              cache_file = "${dnscrypt-resolvers}/v3/odoh-servers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };

            sources.odoh-relays = {
              cache_file = "${dnscrypt-resolvers}/v3/odoh-relays.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };

            server_names = [
              "odoh-cloudflare"
              "odoh-snowstorm"
              # Workaround when odoh is not available
              "controld-unfiltered"
              "mullvad-doh"
            ];

            # This creates the [anonymized_dns] section in dnscrypt-proxy.toml
            anonymized_dns = {
              skip_incompatible = true;
              routes = [
                {
                  server_name = "odoh-snowstorm";
                  via = [ "odohrelay-crypto-sx" ];
                }
                {
                  server_name = "odoh-cloudflare";
                  via = [ "odohrelay-crypto-sx" ];
                }
              ];
            };

            ipv6_servers = hasIPv6Internet;
            block_ipv6 = !hasIPv6Internet;
            require_dnssec = true;
            require_nolog = false;
            require_nofilter = false;
            odoh_servers = true;
            dnscrypt_servers = true;
          };
        };
      };
    };
}
