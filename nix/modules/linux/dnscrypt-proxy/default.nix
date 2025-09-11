{ pkgs, config, lib, ... }:

let
  settings = builtins.readFile ./dnscrypt-proxy.toml;
in
{
  # Install the package
  home.packages = with pkgs; [ dnscrypt-proxy2 nftables ];

  # Generate the TOML config file
  home.file.".dnscrypt-proxy.toml".text = settings;

  # Define the systemd user service to run DNSCrypt-proxy
  systemd.user.services.dnscrypt-proxy = {
    Unit = {
      Description = "DNSCrypt-proxy DNS proxy";
      After = [ "network.target" "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy -config ${
          config.home.file.".dnscrypt-proxy.toml".source
        }";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  # A workaround for non NixOS, need to manually run the setup script
  # on non NixOS.
  home.file."bin/set-dnscrypt-resolv.sh" = {
    executable = true;
    text = ''
      #!/bin/sh

      # Create temporary nftables rules file
      NFT_RULES=$(mktemp)
      cat > $NFT_RULES << EOF
      table inet dnscrypt_redirect {
        chain output {
          type nat hook output priority -100; policy accept;
          ip daddr 127.0.0.1 tcp dport 53 redirect to :5353
          ip daddr 127.0.0.1 udp dport 53 redirect to :5353
          ip6 daddr ::1 tcp dport 53 redirect to :5353
          ip6 daddr ::1 udp dport 53 redirect to :5353
        }
      }
      EOF

      # Apply nftables rules (clear existing table to avoid duplicates)
      sudo nft flush table dnscrypt_redirect 2>/dev/null || true
      sudo nft -f $NFT_RULES

      # Clean up
      rm -f $NFT_RULES

      # Apply /etc/resolv.conf
      sudo tee /etc/resolv.conf > /dev/null << EOF
      nameserver ::1
      nameserver 127.0.0.1
      options edns0
      EOF
    '';
  };

  # Run the script every time the system restart
  home.activation.setDnscryptResolv =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run echo 'Please run `bash ${config.home.homeDirectory}/bin/set-dnscrypt-resolv.sh` manually.'
    '';
}
