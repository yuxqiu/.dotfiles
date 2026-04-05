{ inputs, ... }:
{
  config.flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.ssh-agent-ac.packages.${pkgs.stdenv.system}.ssh-agent-ac ];

      services.ssh-agent = {
        enable = true;

        defaultMaximumIdentityLifetime = null;
      };
    };

  config.flake.modules.homeManager.linux-desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      clearSshKeys = pkgs.writeShellScript "clear-ssh-keys" ''
        #!${pkgs.bash}/bin/bash
        set +e

        sock="$XDG_RUNTIME_DIR/${config.services.ssh-agent.socket}"
        if [ -S "$sock" ]; then
          SSH_AUTH_SOCK="$sock" ${pkgs.openssh}/bin/ssh-add -D 2>/dev/null || true
        fi
      '';

      watchSuspend = pkgs.writeShellScript "watch-suspend-and-clear-ssh-keys" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        ${pkgs.glib}/bin/gdbus monitor \
          --system \
          --dest org.freedesktop.login1 \
          --object-path /org/freedesktop/login1 \
        | while read -r line; do
            case "$line" in
              *PrepareForSleep*true*)
                ${clearSshKeys}
                ;;
            esac
          done
      '';
    in
    {
      # Ensure it starts after the graphical session is up.
      # This makes it able to pick up env var like DISPLAY.
      systemd.user.services.ssh-agent = {
        Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
        Unit = {
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
      };

      systemd.user.services.ssh-agent.Service.Environment = lib.mkAfter [
        "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
      ];

      systemd.user.services.ssh-agent-suspend-clear = {
        Unit = {
          Description = "Clear SSH agent keys before suspend";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${watchSuspend}";
          Restart = "always";
          RestartSec = 1;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      wayland.windowManager.niri.settings.window-rule = lib.mkAfter [
        {
          match = {
            _props."app-id" = "ssh-askpass";
          };

          background-effect.blur = true;
          opacity = 0.6;
        }
      ];
    };

  config.flake.modules.homeManager.darwin-desktop =
    { pkgs, ... }:
    {
      launchd.agents.ssh-agent.config.EnvironmentVariables = {
        SSH_ASKPASS = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
      };
    };
}
