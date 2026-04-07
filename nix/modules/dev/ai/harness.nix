{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Core CLI utilities
        ripgrep
        coreutils
        findutils
        gh
        gnused
        gawk
        gnugrep
        jq
        git
        gnumake
        gnutar
        gzip
        xz

        # PDF tools
        poppler-utils
        # ocrmypdf
        tesseract
      ];
    };
}
