{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ captive-browser ];
      home.file.".config/captive-browser.toml".source = ./captive-browser.toml;

      # Add a browser profile to firefox
      programs.firefox.profiles."captive-browser" = {
        id = 1;
      };
    };
}
