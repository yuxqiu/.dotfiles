{
  flake.modules.nixos.man = { pkgs, ... }: {
    documentation.man.enable = true;

    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
      glibcInfo
    ];
  };
}
