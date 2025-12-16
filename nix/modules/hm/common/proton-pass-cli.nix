{ config, inputs, pkgs, ... }:

let
  proton-pass-cli =
    inputs.proton-pass-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = [ proton-pass-cli ];

  # Session Verification
  # - Use `login` rather than `info` as recommended in https://protonpass.github.io/pass-cli/commands/info/#session-verification
  #   because `login` is way faster.
  home.sessionVariablesExtra = ''
    export PROTON_PASS_SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/${config.services.ssh-agent.socket}"
  '';

  programs.zsh.initContent = ''
    if ! ${proton-pass-cli}/bin/pass-cli login 2>/dev/null; then
      ${proton-pass-cli}/bin/pass-cli login
      SSH_AUTH_SOCK="$PROTON_PASS_SSH_AUTH_SOCK" ${proton-pass-cli}/bin/pass-cli ssh-agent load
    fi
  '';

  programs.bash.initExtra = ''
    if ! ${proton-pass-cli}/bin/pass-cli login 2>/dev/null; then
      ${proton-pass-cli}/bin/pass-cli login
      SSH_AUTH_SOCK="$PROTON_PASS_SSH_AUTH_SOCK" ${proton-pass-cli}/bin/pass-cli ssh-agent load
    fi
  '';
}
