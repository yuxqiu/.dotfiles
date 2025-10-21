{ ... }: {
  config = {
    environment = { etc = { "dnscrypt-proxy".source = ./dnscrypt-proxy; }; };
  };
}
