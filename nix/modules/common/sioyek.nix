{ config, pkgs, ... }: {
  programs.sioyek = {
    enable = true;
    bindings = { "goto_tab" = "gt"; };
    config = {
      "check_for_updates_on_startup" = "0";
      "super_fast_search" = "1";
      "show_document_name_in_statusbar" = "1";
      "show_closest_bookmark_in_statusbar" = "1";
    };
    package = (config.lib.nixGL.wrap pkgs.sioyek);
  };

  xdg.desktopEntries = {
    sioyek = {
      name = "Sioyek";
      comment =
        "Sioyek is a PDF viewer designed for reading research papers and technical books";
      exec = "${pkgs.sioyek}/bin/sioyek %f";
      terminal = false;
      startupNotify = false;
      type = "Application";
      categories = [ "Office" "Viewer" ];
      mimeType = ["application/pdf"];
    };
  };
}
