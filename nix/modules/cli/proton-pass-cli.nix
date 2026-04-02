{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      pass-ssh = pkgs.writeShellScriptBin "pass-ssh" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        PATH="${pkgs.proton-pass-cli}/bin"

        if ! pass-cli test &>/dev/null; then
          pass-cli login || exit 1
        fi

        pass-cli ssh-agent load --vault-name ssh
        pass-cli logout
      '';
    in
    {
      home.packages = with pkgs; [
        pass-ssh
        proton-pass-cli
      ];
    };
}
