{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "ssh-copy-id-general" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          tmp_key="$(mktemp --suffix=.pub)"
          trap 'rm -f "$tmp_key"' EXIT
          printf '%s\n' '${config.my.user.keys."general-ssh"}' > "$tmp_key"
          exec ${pkgs.openssh}/bin/ssh-copy-id -f -i "$tmp_key" "$@"
        '')
      ];
    };
}
