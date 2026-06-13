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
}
