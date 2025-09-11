{ pkgs, ... }: {
  imports = [ ./fzf.nix ./git.nix ./editorconfig.nix ./python.nix ./git-fame.nix ./nixgl.nix ./zsh.nix ./sioyek.nix ./alacritty.nix ./nvim.nix ];

  home.packages = with pkgs; [
    nixfmt-classic
    nixd

    # firefox
    git-crypt
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
}
