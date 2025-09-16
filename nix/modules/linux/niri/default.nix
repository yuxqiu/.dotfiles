{ pkgs, ... }: {
  # install niri on sys package manager for now
  home.packages = with pkgs; [
    blueman
    clipman
    desktop-file-utils
    networkmanagerapplet
    xwayland-satellite
    swaybg
    wl-clipboard
  ];

  home.file.".config/niri/5120x2880.png".source = ./5120x2880.png;
  home.file.".config/niri/config.kdl".source = ./config.kdl;
  home.file.".config/niri/dictation".source = ./dictation;
}
