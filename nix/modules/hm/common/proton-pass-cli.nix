{ inputs, pkgs, ... }:

let
  proton-pass-cli = inputs.proton-pass-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ proton-pass-cli ];

  programs.zsh.siteFunctions.pass-ssh = ''
    if ! pass-cli test &>/dev/null; then
      pass-cli login || return 1
    fi

    pass-cli ssh-agent load
    pass-cli logout
  '';
}
