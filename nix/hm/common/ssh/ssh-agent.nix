{ inputs, pkgs, ... }:
{
  imports = [ ./ssh-agent-ac.nix ];

  services.ssh-agent-ac = {
    enable = true;
    package = inputs.self.packages.${pkgs.stdenv.system}.ssh-agent-ac;

    defaultMaximumIdentityLifetime = null;

    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
