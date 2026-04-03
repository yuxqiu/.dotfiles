{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      # virtual camera requires: v4l2loopback-dkms
      programs.obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
          droidcam-obs
        ];
      };
    };
}
