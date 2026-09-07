{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      sops-update = pkgs.writeShellApplication {
        name = "sops-update";
        runtimeInputs = with pkgs; [
          ssh-to-age
          neovim
          sops
        ];
        text = ''
          set -euo pipefail

          usage() {
            echo "Usage: sops-update <key> <file>" >&2
            exit 1
          }

          if [ "$#" -ne 2 ]; then
            usage
          fi

          key_path="$1"
          file="$2"
          ssh_to_age_bin="$(command -v ssh-to-age)"

          if [ -r "$key_path" ]; then
            age_key="$("$ssh_to_age_bin" -private-key -i "$key_path")"
          else
            age_key="$(sudo "$ssh_to_age_bin" -private-key -i "$key_path")"
          fi
          SOPS_AGE_KEY="$age_key" \
            EDITOR="nvim" \
            sops "$file"
        '';
      };

      sops-update-key = pkgs.writeShellApplication {
        name = "sops-update-key";
        runtimeInputs = with pkgs; [
          coreutils
          git
          ssh-to-age
          gnugrep
          gawk
          gnused
          sops
        ];
        text = ''
            set -euo pipefail

            usage() {
              echo "Usage: sops-update-key <mode> <decrypt_key> <key> <file>" >&2
              echo "Modes: add, remove" >&2
              echo "  <decrypt_key>: a key you currently hold, used to perform the update" >&2
              echo "  add:    <key> is the new key to add" >&2
              echo "  remove: <key> is the key to remove (may be <decrypt_key> itself)" >&2
              exit 1
            }

            if [ "$#" -ne 4 ]; then
              usage
            fi

            mode="$1"
            decrypt_key_path="$2"
            key_path="$3"
            file="$4"
            ssh_to_age_bin="$(command -v ssh-to-age)"

            case "$mode" in
              add|remove)
                ;;
              *)
                usage
                ;;
            esac

            find_sops_root() {
              if [ -f ".sops.yaml" ]; then
                pwd
                return 0
              fi

              if git rev-parse --show-toplevel >/dev/null 2>&1; then
                root="$(git rev-parse --show-toplevel)"
                if [ -f "$root/nix/.sops.yaml" ]; then
                  echo "$root/nix"
                  return 0
                fi
                if [ -f "$root/.sops.yaml" ]; then
                  echo "$root"
                  return 0
                fi
              fi

              return 1
            }

            sops_root="$(find_sops_root || true)"
            if [ -z "$sops_root" ]; then
              echo "Could not find .sops.yaml" >&2
              exit 1
            fi

            cd "$sops_root"

            sops_yaml="$sops_root/.sops.yaml"

            decrypt_key_pub_path="$decrypt_key_path.pub"
            if [ ! -f "$decrypt_key_pub_path" ]; then
              echo "Missing SSH public key: $decrypt_key_pub_path" >&2
              exit 1
            fi

            target_key_pub_path="$key_path.pub"
            target_key_name="$(basename "$key_path")"
            target_key_name="$(printf "%s" "$target_key_name" | sed 's/\.pub$//')"
            if [ ! -f "$target_key_pub_path" ]; then
              echo "Missing SSH public key: $target_key_pub_path" >&2
              exit 1
            fi

            decrypt_key="$(cat "$decrypt_key_pub_path" | "$ssh_to_age_bin")"
            target_key="$(cat "$target_key_pub_path" | "$ssh_to_age_bin")"

            if [ -r "$decrypt_key_path" ]; then
              identity="$("$ssh_to_age_bin" -private-key -i "$decrypt_key_path")"
            else
              identity="$(sudo "$ssh_to_age_bin" -private-key -i "$decrypt_key_path")"
            fi

            case "$mode" in
              add)
                if ! grep -Fq "$decrypt_key" "$sops_yaml"; then
                  echo "decrypt_key not found in .sops.yaml" >&2
                  exit 1
                fi
                if grep -Fq "$target_key" "$sops_yaml"; then
                  echo "Key already present in .sops.yaml" >&2
                  exit 1
                fi
                ;;
              remove)
                if ! grep -Fq "$target_key" "$sops_yaml"; then
                  echo "Key not found in .sops.yaml" >&2
                  exit 1
                fi
                ;;
            esac

            tmp="$(mktemp)"
            case "$mode" in
              add)
                if ! awk -v old="$decrypt_key" -v new="$target_key" -v new_name="$target_key_name" '
                  {
                    if (old_name == "" && index($0, old)) {
                      if (match($0, /&[^[:space:]]+/)) {
                        old_name = substr($0, RSTART + 1, RLENGTH - 1)
                      }
                  }
                  if (!added_key && index($0, old)) {
                    print
                    line = $0
                    line = gensub(/&[^[:space:]]+/, "\\&" new_name, 1, line)
                    line = gensub(old, new, 1, line)
                    print line
                    added_key = 1
                    next
                  }
                  if (old_name != "" && index($0, "*" old_name)) {
                    print
                    print gensub(/\*[^[:space:]]+/, "*" new_name, 1, $0)
                    added_ref = 1
                    next
                  }
                  print
                }
                END {
                  if (!added_key || !added_ref) {
                    exit 3
                  }
                }
              ' "$sops_yaml" > "$tmp"; then
                  rm -f "$tmp"
                  echo "Failed to add new key to .sops.yaml" >&2
                  exit 1
                fi
                ;;
              remove)
                if ! awk -v old="$target_key" '
                  {
                    if (old_name == "" && index($0, old)) {
                      if (match($0, /&[^[:space:]]+/)) {
                        old_name = substr($0, RSTART + 1, RLENGTH - 1)
                      }
                  }
                  if (index($0, old)) {
                    removed_key = 1
                    next
                  }
                  if (old_name != "" && index($0, "*" old_name)) {
                    removed_ref = 1
                    next
                  }
                  print
                }
                END {
                  if (!removed_key) {
                    exit 3
                  }
                  if (old_name != "" && !removed_ref) {
                    exit 3
                  }
                }
              ' "$sops_yaml" > "$tmp"; then
                  rm -f "$tmp"
                  echo "Failed to remove key from .sops.yaml" >&2
                  exit 1
                fi
                ;;
          esac

          mv "$tmp" "$sops_yaml"

          SOPS_AGE_KEY="$identity" \
            sops updatekeys "$file"
        '';
      };
    in
    {
      home.packages = [
        sops-update
        sops-update-key
      ];
    };
}
