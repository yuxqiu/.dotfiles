{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  patchedDmsShell = inputs.dms.packages.${pkgs.stdenv.system}.default.overrideAttrs (old: {
    postInstall =
      builtins.replaceStrings
        [
          ''
            substituteInPlace $out/share/quickshell/dms/assets/pam/fprint \
              --replace-fail pam_fprintd.so ${pkgs.fprintd}/lib/security/pam_fprintd.so''
        ]
        [ "" ]
        old.postInstall;
  });

  patchedDmsPkgs = {
    dms-shell = patchedDmsShell;
    dgop = inputs.dms.inputs.dgop.packages.${pkgs.stdenv.system}.dgop;
    quickshell = inputs.dms.inputs.quickshell.packages.${pkgs.stdenv.system}.default;
  };

  patchedModule = import (inputs.dms + "/distro/nix/home.nix") {
    inherit config pkgs lib;
    dmsPkgs = patchedDmsPkgs;
  };
in
{
  imports = [
    ./scripts/dms-focused-output.nix
    patchedModule
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false;
    enableAudioWavelength = true;
    enableCalendarEvents = false;
  };

  xdg.configFile."DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/nix/hm/linux/dms/settings.json";
}
