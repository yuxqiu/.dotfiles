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
  ];

  home.packages = with pkgs; [
    bottom
    ffmpeg
    git-crypt
    git-lfs
    hyperfine
    lazydocker
    less
    pandoc
    uv
    rustup
    tealdeer
    tectonic
    (texliveSmall.withPackages (ps: with ps; [ latexindent synctex ]))
    tokei
    tree
    typst
    typos
    onefetch
    openssl
    kondo
  ];

  home.stateVersion = "25.11";

  # Ensure fonts are available
  fonts.fontconfig.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
}
