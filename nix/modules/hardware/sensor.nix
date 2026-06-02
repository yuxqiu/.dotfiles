{
  flake.modules.nixos.sensor = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ iio-sensor-proxy ];
    services.udev.packages = with pkgs; [ iio-sensor-proxy ];
  };
}
