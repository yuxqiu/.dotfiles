{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = false;
      settings = {
        controller = "disabled";
        origin_web_ui_allowed = "pc";
        bind_address = "127.0.0.1";
      };
    };

    services.tailscale.serve = {
      services.sunshine = {
        endpoints = {
          "https:47990" = "http://127.0.0.1:47990";
          "tcp:47989" = "tcp://127.0.0.1:47989";
          "tcp:48010" = "tcp://127.0.0.1:48010";
        };
      };
    };
  };
}
