{
  flake.modules.homeManager.nautilus =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];

      xdg.mimeApps = {
        associations.added = {
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        };

        defaultApplications = {
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        };
      };
    };

  flake.modules.nixos.nautilus = {
    # Trash, network browsing, and other GIO virtual filesystems
    services.gvfs.enable = true;
  };
}
