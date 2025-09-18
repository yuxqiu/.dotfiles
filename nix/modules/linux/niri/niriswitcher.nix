{ pkgs, ... }: {
  home.packages = with pkgs; [ niriswitcher ];

  xdg.configFile."niriswitcher/config.toml".text = ''
    separate_workspaces = false
  '';
}
