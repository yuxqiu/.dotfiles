{ ... }: {
  programs.waybar = {
    enable = true;
    settings = [{
      height = 20;
      modules-left = [ "niri/workspaces" ];
      modules-right = [
        "pulseaudio#output"
        "pulseaudio#input"
        "network"
        "bluetooth"
        "memory"
        "cpu"
        "battery"
        "privacy"
        "clock"
        "tray"
      ];
      "niri/workspaces" = {
        "format" = "{icon}";
        "format-icons" = {
          "browser" = "";
          "discord" = "";
          "chat" = "<b></b>";
          "active" = "";
          "default" = "";
        };
      };
      "tray" = { "spacing" = 10; };
      "clock" = {
        "format" = " {:%H:%M:%S}";
        "interval" = 1;
        "tooltip-format" = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
        "format-alt" = " {:%Y-%m-%d}";
      };
      "cpu" = {
        "format" = " {usage}%";
        "tooltip" = false;
      };
      "memory" = {
        "format" = " {}%";
        "tooltip" = false;
      };
      "battery" = {
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{icon} {capacity}%";
        "format-alt" = "{icon}";
        "format-charging" = " {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-icons" = [ "" "" "" "" "" "" "" "" "" "" "" "" ];
        "tooltip" = false;
      };
      "network" = {
        "format-wifi" = " {signalStrength}%";
        "format-ethernet" = "";
        "tooltip-format-wifi" = ''
          {essid}	{ipaddr}/{cidr}
          {ifname} via {gwaddr}'';
        "tooltip-format-ethernet" = "{ipaddr}/{cidr}";
        "format-disconnected" = "";
        "tooltip" = true;
        "on-click-middle" = "pkill nm-applet";
        "on-click-right" = "nm-applet";
      };
      "pulseaudio#output" = {
        "format" = "{icon} {volume}%";
        "format-bluetooth" = "{volume}% {icon}";
        "format-muted" = "";
        "format-icons" = {
          "headphones" = "";
          "handsfree" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [ "" "" ];
        };
        "scroll-step" = 1;
        "on-click-right" = "pavucontrol";
      };
      "pulseaudio#input" = {
        "format-source" = "";
        "format-source-muted" = "";
        "format" = "{format_source}";
      };
      "privacy" = {
        "icon-spacing" = 4;
        "icon-size" = 14;
        "transition-duration" = 250;
      };
      "bluetooth" = {
        "format" = "";
        "format-off" = "";
        "format-connected" = " {num_connections}";
        "tooltip-format" = ''
          {controller_alias}	{controller_address}
          {num_connections} connected'';
        "tooltip-format-connected" = ''
          {controller_alias}	{controller_address}
          {num_connections} connected
          {device_enumerate}'';
        "tooltip-format-enumerate-connected" =
          "{device_alias}	{device_address}";
        "tooltip-format-enumerate-connected-battery" =
          "{device_alias}	{device_address}	{device_battery_percentage}%";
        "on-click-middle" = "pkill blueman-applet";
        "on-click-right" = "blueman-applet";
      };
    }];
    style = ./style.css;
  };
}
