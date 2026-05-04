{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      niri-floating-sidebar = pkgs.writeShellApplication {
        name = "niri-floating-sidebar";
        runtimeInputs = with pkgs; [
          coreutils
          gnugrep
          gnused
          jq
          niri
        ];
        text = builtins.readFile ./niri-floating-sidebar.sh;
      };

      niri-sidebar-auto-reorder = pkgs.writeShellApplication {
        name = "niri-sidebar-auto-reorder";
        runtimeInputs = [
          pkgs.niri
        ];
        text =
          builtins.replaceStrings
            [ "$HOME/.config/niri/scripts/niri-floating-sidebar.sh" ]
            [ "${niri-floating-sidebar}/bin/niri-floating-sidebar" ]
            (builtins.readFile ./niri-sidebar-auto-reorder.sh);
      };
    in
    {
      wayland.windowManager.niri.settings = {
        binds = {
          "Mod+A" = {
            _props.hotkey-overlay-title = "Toggle Sidebar Floating";
            spawn-sh = "${niri-floating-sidebar}/bin/niri-floating-sidebar toggle";
          };
          "Mod+S" = {
            _props.hotkey-overlay-title = "Toggle Sidebar Visibility";
            spawn-sh = "${niri-floating-sidebar}/bin/niri-floating-sidebar hide";
          };
          "Mod+Shift+A" = {
            switch-focus-between-floating-and-tiling = [ ];
          };
        };

        spawn-at-startup = [
          [ "${niri-sidebar-auto-reorder}/bin/niri-sidebar-auto-reorder" ]
        ];
      };
    };
}
