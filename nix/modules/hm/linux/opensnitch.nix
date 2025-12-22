{ pkgs, ... }:
{
  home.packages = with pkgs; [ opensnitch-ui ];
  services.opensnitch-ui.enable = true;
}
