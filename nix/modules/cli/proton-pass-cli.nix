{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      pass-ssh = pkgs.writeShellApplication {
        name = "pass-ssh";
        runtimeInputs = with pkgs; [ proton-pass-cli ];
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
      home.packages = with pkgs; [
        pass-ssh
        proton-pass-cli
      ];
    };
}
