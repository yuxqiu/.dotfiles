{ pkgs, ... }: {
  imports = [ ./fzf.nix ./git.nix ./editorconfig.nix ];

  home.packages = with pkgs; [
    nixfmt-classic
    nixd

    # alacritty
    # firefox
    git-crypt
    # TODO: fix this
    # git-fame
    hyperfine
    lazydocker
    # neovim
    pandoc
    # ruby
    tectonic
    tokei
    tree
    typst
    typos
    onefetch
    openssl
  ];

  home.stateVersion = "25.05";
}
