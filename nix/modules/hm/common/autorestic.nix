{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autorestic
    restic
  ];

  # Config file is managed manually
  # - See: https://autorestic.vercel.app/
  # - Until: https://github.com/cupcakearmy/autorestic/issues/323
}
