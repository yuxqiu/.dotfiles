{
  flake.modules.homeManager.dms =
    { pkgs, ... }:
    {
      programs.dank-material-shell.plugins.quickCapture.enable = true;

      home.packages = with pkgs; [
        imagemagick
        img2pdf
        tesseract
        zbar
      ];
    };
}
