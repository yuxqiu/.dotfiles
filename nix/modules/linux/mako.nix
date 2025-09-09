{ pkgs, ... }: {
  home.packages = with pkgs; [ mako ];

  services.mako = {
    enable = true;
    settings = {
      background-color = "#24273a";
      text-color = "#cad3f5";
      border-color = "#f4dbd6";
      progress-color = "over #363a4f";
      "urgency=high" = { border-color = "#f5a97f"; };
    };
  };

  systemd.user.services.mako = {
    Unit = {
      Description = "Mako notification daemon";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
