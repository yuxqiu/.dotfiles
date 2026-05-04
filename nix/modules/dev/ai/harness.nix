{
  flake.modules.homeManager.ai =
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
        nodejs
        tmux
        xxd
        xz

        # PDF tools
        poppler-utils
        # ocrmypdf
        tesseract
      ];
    };
}
