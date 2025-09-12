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
  ];

  home.packages = with pkgs; [
    ffmpeg
    # firefox
    git-crypt
    git-lfs
    hyperfine
    lazydocker
    pandoc
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

  home.stateVersion = "25.05";

  # Ensure fonts are available
  fonts.fontconfig.enable = true;
}
