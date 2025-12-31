{ pkgs, ... }:

let
  # TODO: replace this with a more elegant ssh-askpass
  sshAskpass = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
in
{
  # enable ssh-askpass confirmation popup
  home.sessionVariables.SSH_ASKPASS = sshAskpass;
  systemd.user.sessionVariables = {
    SSH_ASKPASS = sshAskpass;
  };
}
