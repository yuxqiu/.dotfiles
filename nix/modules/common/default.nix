{ pkgs, ... }: {
  imports = [ ./fzf.nix ./git.nix ./editorconfig.nix ];

  home.packages = with pkgs; [
    nixfmt
    nixd

    # alacritty
    # firefox
    git-crypt
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
