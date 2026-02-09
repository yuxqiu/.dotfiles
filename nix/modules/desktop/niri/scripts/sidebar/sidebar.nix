{
  flake.modules.homeManager.linux-gui = {
    home.file.".config/niri/scripts/niri-floating-sidebar.sh" = {
      source = ./niri-floating-sidebar.sh;
      executable = true;
    };
    home.file.".config/niri/scripts/niri-sidebar-auto-reorder.sh" = {
      source = ./niri-sidebar-auto-reorder.sh;
      executable = true;
    };
  };
}
