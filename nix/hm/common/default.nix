{ pkgs, ... }:
{
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
    ./bash.nix
    ./ssh/default.nix
    ./jj.nix
    ./proton-pass-cli.nix
    ./zed/default.nix
    ./stylix/default.nix
    ./session.nix
    ./fonts.nix
    ./lowfi/default.nix
  ];

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
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
}
