{
  flake.modules.homeManager.proton-pass-cli =
    { pkgs, ... }:
    let
      wrapped-pass-cli = pkgs.symlinkJoin {
        name = "pass-cli";
        paths = [ pkgs.proton-pass-cli ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/pass-cli \
            --set-default PROTON_PASS_LINUX_KEYRING dbus
        '';
      };

      pass-ssh = pkgs.writeShellApplication {
        name = "pass-ssh";
        runtimeInputs = [ wrapped-pass-cli ];
        text = ''
          set -euo pipefail

          if ! pass-cli test &>/dev/null; then
            pass-cli login || exit 1
          fi

          pass-cli ssh-agent load --vault-name ssh
          pass-cli logout
        '';
      };
    in
    {
      home.packages = [
        pass-ssh
        wrapped-pass-cli
      ];
    };
}
