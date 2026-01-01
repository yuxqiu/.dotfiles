{ pkgs, ... }:
{
  # TODO: replace this with a more elegant ssh-askpass
  services.ssh-agent-ac.sshAskpass = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
}
