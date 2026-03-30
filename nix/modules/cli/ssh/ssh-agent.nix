{ inputs, ... }:
{
  config.flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      imports = [ (inputs.self + /packages/ssh-agent-ac.nix) ];

      services.ssh-agent-ac = {
        enable = true;
        package = inputs.ssh-agent-ac.packages.${pkgs.stdenv.system}.ssh-agent-ac;

        defaultMaximumIdentityLifetime = null;

        enableBashIntegration = true;
        enableZshIntegration = true;
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

        sock="$XDG_RUNTIME_DIR/${config.services.ssh-agent-ac.socket}"
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
      services.ssh-agent-ac.sshAskpass = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

      systemd.user.services.ssh-agent-ac-suspend-clear = {
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

  config.flake.modules.homeManager.darwin-gui =
    { pkgs, ... }:
    {
      services.ssh-agent-ac.sshAskpass = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
    };
}
