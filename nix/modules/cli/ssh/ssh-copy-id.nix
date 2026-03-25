{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "ssh-copy-id-general" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          exec ${pkgs.openssh}/bin/ssh-copy-id -i <(
            printf '%s\n' '${config.my.user.keys."general-ssh"}'
          ) "$@"
        '')
      ];
    };
}
