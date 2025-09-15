{ pkgs, ... }: {
  imports = [
    ./fzf.nix
    ./git.nix
    ./editorconfig.nix
    ./python.nix
    ./git-fame.nix
    ./nixgl.nix
    ./zsh.nix
    ./sioyek.nix
    ./alacritty.nix
    ./nvim.nix
    ./vscode.nix
    ./firefox/default.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
    # firefox
    git-crypt
    git-lfs
    hyperfine
    lazydocker
    pandoc
    uv
    # ruby
    rustup
    tectonic
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
}
