{ pkgs, ... }: {
  imports = [ ./fzf.nix ./git.nix ./editorconfig.nix ./python.nix ./git-fame.nix ./nixgl.nix ./zsh.nix ../sioyek.nix ];

  home.packages = with pkgs; [
    nixfmt-classic
    nixd

    # alacritty
    # firefox
    git-crypt
    hyperfine
    lazydocker
    # neovim
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
}
