{ pkgs, ... }: {
  # Here, only packages needed by niri directly are managed
  home.packages = with pkgs; [ xwayland-satellite ];

  # The following packages are managed by systems for now:
  # - niri itself
  # - portals (gtk and gnome)
  # - swayidle and swaylock

  home.file.".config/niri/5120x2880.png".source = ./5120x2880.png;
  home.file.".config/niri/config.kdl".source = ./config.kdl;
  home.file.".config/niri/dictation".source = ./dictation;
}
