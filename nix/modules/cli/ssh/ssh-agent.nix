{ inputs, ... }:
{
  config.flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      imports = [ ./_ssh-agent-ac.nix ];

      services.ssh-agent-ac = {
        enable = true;
        package = inputs.ssh-agent-ac.packages.${pkgs.stdenv.system}.ssh-agent-ac;

        defaultMaximumIdentityLifetime = null;

        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };

  config.flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      services.ssh-agent-ac.sshAskpass = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };

  config.flake.modules.homeManager.darwin-gui =
    { pkgs, ... }:
    {
      services.ssh-agent-ac.sshAskpass = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
    };
}
