{
  flake.modules.nixos.pipewire = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.easyeffects = {
    services.easyeffects = {
      enable = true;
      preset = "noise-reduction";
      extraPresets = {
        "noise-reduction" = {
          input = {
            blocklist = [ ];
            "plugins_order" = [ "rnnoise#0" ];
            "rnnoise#0" = {
              bypass = false;
              "enable-vad" = false;
              "input-gain" = 0.0;
              "model-path" = "";
              "output-gain" = 0.0;
              release = 20.0;
              "vad-thres" = 50.0;
              wet = 0.0;
            };
          };
        };
      };
    };
  };
}
