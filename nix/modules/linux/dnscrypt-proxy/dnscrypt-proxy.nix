{ ... }: {
  config = {
    environment = {
      etc = {
        "dnscrypt-proxy".source = ./dnscrypt-proxy;
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
  };
}
