{
  flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ wayscriber ];

      xdg.desktopEntries.wayscriber = {
        name = "Wayscriber";
        comment = "Live overlay for drawing, annotating, and screenshots (Wayland whiteboard)";
        genericName = "Drawing Overlay";
        exec = "wayscriber --active";
        icon = "accessories-drawing";
        terminal = false;
        type = "Application";
        categories = [
          "Graphics"
          "Utility"
          "2DGraphics"
        ];
        startupNotify = false;
        settings = {
          Keywords = "drawing;whiteboard;annotate;screenshot;wayland;overlay";
        };
      };
    };
}
