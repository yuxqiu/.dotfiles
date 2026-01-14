{
  config,
  lib,
  pkgs,
  ...
}:

let
  lowfi = pkgs.callPackage ./lowfi.nix { };
  trackList = ./lofigirl.txt;

  # note: must symlink the txt as the created dbus name is directly related
  # to the path of the provided track list
  lofiWrapped = pkgs.writeShellScriptBin "lofigirl" ''
    exec ${lib.getExe lowfi} --track-list "${config.xdg.configHome}/lofi/lofigirl.txt" "$@"
  '';

in
{
  xdg.configFile."lofi/lofigirl.txt" = {
    source = trackList;
  };

  home.packages = [
    lowfi
    lofiWrapped
  ];
}
