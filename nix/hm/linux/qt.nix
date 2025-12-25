{
  config,
  lib,
  pkgs,
  ...
}:
{
  qt = {
    enable = true;
    platformTheme = {
      # stylix: need to match its qt module
      name = "qtct";
      # overwrite packages used by qtct, kdePackages.qt6ct is better than
      # qt6Packages.qt6ct in handling KDE applications (like dolphin).
      #
      # home-manager: need to sync with upstream dependencies
      package = with pkgs; [
        libsForQt5.qt5ct
        kdePackages.qt6ct
      ];
    };
    style.name = "kvantum";
  };

  # Prepend (must prepend) the following path to QT_PLUGIN_PATH
  #
  # Note: qt module injects `QT_PLUGIN_PATH` to the environment, which
  # enables qt applications to use `qt5ct` and `qt6ct` installed in nix.
  # Specifically, these platform themes are loaded by using corresponding
  # plugins in the plugin path (e.g., plugins/platformthemes/libqt5ct.so).
  # However, `QT_PLUGIN_PATH` will interfere with packages installed via
  # system's package manager as they cannot load plugins that are installed in
  # system but not in nix. Thus, we need to inject (may be system-dependent)
  # `/usr/lib/qt{5,6}/plugins/platformthemes` into the QT_PLUGIN_PATH.
  #
  # One last caveat is that this is not foolproof: nix's Qt might not be
  # incompatible with system's qt. So, it's better to also install qt{5,6}ct
  # and kvantum using your system's package manager.
  home.sessionSearchVariables = {
    QT_PLUGIN_PATH = [
      "/usr/lib64/qt5/plugins"
      "/usr/lib64/qt6/plugins"
    ];
  };
  systemd.user.sessionVariables = {
    # Overwrite the path set in home-manager's qt module
    QT_PLUGIN_PATH = lib.mkForce (
      lib.concatStringsSep ":" config.home.sessionSearchVariables.QT_PLUGIN_PATH
    );
  };

  stylix.targets.qt.enable = true;
}
