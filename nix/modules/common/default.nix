{ pkgs, ... }: {
  home.packages = with pkgs; [
    nixfmt
    nixd

    # alacritty
    difftastic
    # firefox
    # fzf
    # git
    go
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
  ];
  home.stateVersion = "25.05";
}
