{ pkgs, ... }:
{
  services.ssh-agent-ac.sshAskpass = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
}
