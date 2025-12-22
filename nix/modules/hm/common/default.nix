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
    ./ssh.nix
    ./jj.nix
    ./proton-pass-cli.nix
    ./zed/default.nix
    ./stylix/default.nix
  ];

  home.packages = with pkgs; [
    bottom
    cargo-flamegraph
    dig
    duf
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

  # Ensure fonts are available
  fonts.fontconfig.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
}
