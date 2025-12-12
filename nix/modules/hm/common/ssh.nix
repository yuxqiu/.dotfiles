{ pkgs, ... }: {
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
  };

  services.ssh-agent = {
    enable = true;

    defaultMaximumIdentityLifetime = null;

    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
