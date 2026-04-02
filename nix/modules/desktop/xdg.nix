{
  flake.modules.homeManager.linux-desktop = {
    # enable xdg
    xdg.enable = true;

    # let hm to manage xdg user dirs
    xdg.userDirs.enable = true;

    xdg.autostart.enable = true;
    xdg.mime.enable = true;
    xdg.portal.enable = true;
    xdg.terminal-exec.enable = true;
  };

  flake.modules.systemManager.desktop =
    { pkgs, ... }:
    {
      # fusermount3 is required by xdg-document-portal
      environment.systemPackages = with pkgs; [ fuse3 ];

      security.wrappers = {
        fusermount3 = {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.fuse3}/bin/fusermount3";
        };
      };
    };
}
