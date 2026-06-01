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
  };
}
