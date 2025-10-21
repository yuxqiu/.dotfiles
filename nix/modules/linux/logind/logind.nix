{ ... }: {
  config = {
    environment = {
      etc = { "systemd/logind.conf.d".source = ./logind.conf.d; };
    };
  };
}
