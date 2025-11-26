{ ... }: {
  # /etc/greetd/config.toml must be set accordingly
  # - doc: https://danklinux.com/docs/dankgreeter/configuration
  config = {
    environment = { etc = { "greetd/dms-niri.kdl".source = ./dms-niri.kdl; }; };
  };
}
