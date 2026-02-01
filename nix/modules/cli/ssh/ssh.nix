{
  config.flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.ssh = {
        enable = true;
        package = pkgs.openssh;

        # base config
        matchBlocks."*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 300;
          serverAliveCountMax = 3;
          hashKnownHosts = true;
          userKnownHostsFile = "~/.ssh/known_hosts";
        };

        includes = [ "config.d/*" ];
        enableDefaultConfig = false;
      };
    };
}
