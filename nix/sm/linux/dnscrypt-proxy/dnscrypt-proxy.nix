{ pkgs, ... }:
{
  environment = {
    etc = {
      "resolv.conf" = {
        text = ''
          nameserver ::1
          nameserver 127.0.0.1
          options edns0
        '';
        mode = "0644";
      };
    };
  };

  systemd.services.dnscrypt-proxy = {
    description = "DNSCrypt-proxy client - Encrypted/authenticated DNS proxy";
    documentation = [ "https://github.com/jedisct1/dnscrypt-proxy/wiki" ];

    after = [ "network.target" ];
    before = [ "nss-lookup.target" ];
    wants = [ "nss-lookup.target" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Exact store path instead of /usr/bin
      ExecStart = "${pkgs.dnscrypt-proxy}/bin/dnscrypt-proxy -config ${./dnscrypt-proxy.toml}";

      WorkingDirectory = "/";
      Restart = "always";
      RestartSec = 120;

      # Optional environment overrides (kept exactly as original)
      EnvironmentFile = "-/etc/sysconfig/dnscrypt-proxy";

      # Rate limiting (StartLimit* is deprecated, use the new names)
      StartLimitInterval = 5;
      StartLimitBurst = 10;
    };
  };
}
