{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        bottom
        cargo-flamegraph
        dig
        duf
        fastfetch
        ffmpeg
        hyperfine
        jq
        less
        mtr
        openssl
        pandoc
        rsync
        screen
        sqlite
        strace
        tealdeer
        tokei
        tree
        typos
        update-nix-fetchgit
        wget
        which
        zmk-studio
      ];
    };
}
