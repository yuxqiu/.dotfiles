{ inputs, ... }:
{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    let
      nirimap = pkgs.callPackage (inputs.self + /packages/nirimap.nix) { };
    in
    {
      home.packages = [ nirimap ];

      xdg.configFile."nirimap/config.toml".source = pkgs.writeText "nirimap-config.toml" ''
        [display]
        height = 100
        max_width_percent = 0.5
        max_height_percent = 0.8
        anchor = "top-right"
        margin_x = 10
        margin_y = 10
        workspace_mode = "all"

        [appearance]
        background = "#1e1e2e"
        window_color = "#45475a"
        focused_color = "#89b4fa"
        border_color = "#6c7086"
        border_width = 1
        border_radius = 2
        gap = 2
        background_opacity = 0.0
        window_opacity = 0.7
        focused_opacity = 1.0
        workspace_gap = 4
        active_workspace_border_color = "#89b4fa"
        active_workspace_border_width = 2

        [behavior]
        show_on_overview = true
        always_visible = false
        hide_timeout_ms = 1000
        show_for_floating_windows = false
      '';

      # Enable when shown on ovewview only is implemented
      #
      # wayland.windowManager.niri.settings = {
      # spawn-at-startup = [ [ "${nirimap}/bin/nirimap" ] ];
      # };
    };
}
