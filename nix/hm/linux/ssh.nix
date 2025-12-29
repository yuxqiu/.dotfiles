{ pkgs, ... }:

let
  sshAskpass = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
in
{
  # enable ssh-askpass confirmation popup
  home.sessionVariables.SSH_ASKPASS = sshAskpass;
  systemd.user.sessionVariables = {
    SSH_ASKPASS = sshAskpass;
  };
}
