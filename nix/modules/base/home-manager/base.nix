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
        git-crypt
        git-lfs
        hyperfine
        jq
        lazydocker
        less
        mtr
        mosh
        onefetch
        openssl
        pandoc
        rsync
        rustup
        screen
        sqlite
        strace
        tealdeer
        tokei
        tree
        typos
        update-nix-fetchgit
        uv
        wget
        which
        zmk-studio
      ];
    };
}
