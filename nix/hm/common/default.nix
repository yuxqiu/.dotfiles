{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./editorconfig.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./git-fame.nix
    ./home-manager.nix
    ./jj.nix
    ./nix-index.nix
    ./nvim.nix
    ./proton-pass-cli.nix
    ./python.nix
    ./session.nix
    ./sioyek.nix
    ./vscode.nix
    ./zsh.nix

    ./firefox/default.nix
    ./lowfi/default.nix
    ./ssh/default.nix
    ./stylix/default.nix
    ./zed/default.nix
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
    zmk-studio
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
}
