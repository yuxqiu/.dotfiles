{ ... }: {
  services.ssh-agent = {
    enable = true;

    defaultMaximumIdentityLifetime = null;

    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
