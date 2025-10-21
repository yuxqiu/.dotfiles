{ ... }: {
  config = {
    environment = {
      etc = { "NetworkManager/conf.d".source = ./conf.d; };
    };
  };
}
