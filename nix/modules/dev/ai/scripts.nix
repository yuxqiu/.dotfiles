{
  flake.modules.homeManager.ai =
    { pkgs, lib, ... }:
    let
      ask = pkgs.writeShellApplication {
        name = "ask";
        runtimeInputs =
          with pkgs;
          [ opencode ] ++ lib.optionals stdenv.isLinux [ wl-clipboard ] ++ lib.optionals stdenv.isDarwin [ ];
        text = ''
          if [[ $# -eq 0 ]]; then
            echo "Usage: ask <question>" >&2
            exit 1
          fi

          question="$*"

          qdir="$HOME/.questions"
          [[ -d "$qdir" ]] || mkdir -p "$qdir"
          cd "$qdir"

          printf '\n'
          printf '\033[36m┌─────────────────────────────────────────────\033[0m\n'
          printf '\033[36m│ Question:\033[0m \033[33m%s\033[0m\n' "$question"
          printf '\033[36m└─────────────────────────────────────────────\033[0m\n'
          printf '\n'

          opencode run "$question"

          printf '\n'
        '';
      };

      cmd = pkgs.writeShellApplication {
        name = "cmd";
        runtimeInputs =
          with pkgs;
          [ opencode ] ++ lib.optionals stdenv.isLinux [ wl-clipboard ] ++ lib.optionals stdenv.isDarwin [ ];
        text = ''
          if [[ $# -eq 0 ]]; then
            echo "Usage: cmd <description of what you want to do>" >&2
            exit 1
          fi

          desc="$*"

          qdir="$HOME/.questions"
          [[ -d "$qdir" ]] || mkdir -p "$qdir"
          cd "$qdir"

          printf '\n'
          printf '\033[36m│ Generating command for:\033[0m \033[33m%s\033[0m\n' "$desc"
          printf '\n'

          result=$(opencode run "Output exactly one shell command for: $desc. No explanation, no markdown, no backticks. Just the raw command on a single line." 2>/dev/null)

          if [[ $? -ne 0 || -z "$result" ]]; then
            echo "✗ Failed." >&2
            exit 1
          fi

          result="''${result//\`/}"
          result="''${result## }"
          result="''${result%% }"

          if [[ "$(uname)" == "Darwin" ]]; then
            echo -n "$result" | pbcopy
          else
            echo -n "$result" | wl-copy
          fi
          echo "$result"
        '';
      };
    in
    {
      home.packages = [
        ask
        cmd
      ];
    };
}
