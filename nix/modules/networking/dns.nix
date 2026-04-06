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
        rev = "e67cc2e189679f991690ade03d0ee88566d2eb0f";
        hash = "sha256-bk7KZzuqcxKSswOVyqJI5Cx8dSsOCWi3O9DbWg6bVcc=";
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

        # force all domains through this (prevents per-link DNS from overriding)
        # interact with @vpn.nix
        systemd.tmpfiles.rules = [
          "d /etc/systemd/resolved.conf.d 0755 root root - -"
          "f /etc/systemd/resolved.conf.d/domain.conf 0644 root root - [Resolve]\\nDomains=~.\\n"
        ];

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
