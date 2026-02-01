{ inputs, ... }:

{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
        polarity = "dark";
        image = ./wallpapers/1.png;

        fonts = {
          sansSerif = {
            package = pkgs.fira;
            name = "Fira Sans";
          };

          serif = {
            package = pkgs.fira;
            name = "Fira Sans";
          };

          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Mono";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };

      home.file.".wallpapers".source = ./wallpapers;
    };

  flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      stylix = {
        icons = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          light = "Adwaita";
          dark = "Adwaita";
        };

        cursor = {
          name = "catppuccin-mocha-dark-cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
          size = 24;
        };
      };
    };
}
