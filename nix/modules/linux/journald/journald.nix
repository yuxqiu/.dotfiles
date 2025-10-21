{ ... }: {
  config = {
    environment = {
      etc = { "systemd/journald.conf.d".source = ./journald.conf.d; };
    };
  };
}
