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
    { pkgs, lib, ... }:
    {
      services.ssh-agent-ac.sshAskpass = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

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
