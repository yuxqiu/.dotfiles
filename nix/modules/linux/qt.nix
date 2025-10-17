{ ... }: {
  # let qt use gtk3 theme
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
  };
}
