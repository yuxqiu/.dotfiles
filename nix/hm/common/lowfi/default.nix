{
  config,
  lib,
  pkgs,
  ...
}:

let
  lowfi = pkgs.lowfi.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/lowfi \
          --set ALSA_PLUGIN_DIR "${pkgs.alsa-plugins}/lib/alsa-lib" \
          --prefix LD_LIBRARY_PATH : "${
            lib.makeLibraryPath [
              pkgs.pipewire
              pkgs.alsa-lib
            ]
          }"
      ''}
    '';
  });
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
