{ pkgs, ... }: {
  imports = [
    ./fzf.nix
    ./git.nix
    ./editorconfig.nix
    ./python.nix
    ./git-fame.nix
    ./zsh.nix
    ./sioyek.nix
    ./alacritty.nix
    ./nvim.nix
    ./vscode.nix
    ./firefox/default.nix
    ./nixgl.nix
    ./bash.nix
  ];

  home.packages = with pkgs; [
    bottom
    cargo-flamegraph
    dig
    duf
    ffmpeg
    git-crypt
    git-lfs
    hyperfine
    kondo
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
    tectonic
    (texliveSmall.withPackages (ps: with ps; [ latexindent synctex ]))
    tokei
    tree
    typst
    typos
    update-nix-fetchgit
    uv
    wget
    which
  ];

  # Ensure fonts are available
  fonts.fontconfig.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
}
