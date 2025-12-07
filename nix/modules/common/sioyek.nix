{ ... }: {
  programs.sioyek = {
    enable = true;
    bindings = { "goto_tab" = "gt"; };
    config = {
      "check_for_updates_on_startup" = "0";
      "super_fast_search" = "1";
      "show_document_name_in_statusbar" = "1";
      "show_closest_bookmark_in_statusbar" = "1";
      "status_bar_font_size" = "15";
      "font_size" = "15";
    };
  };
}
