{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
          droidcam-obs
        ];
      };
    };
}
