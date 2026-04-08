{ inputs, lib, ... }:
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
              echo "Usage: sops-update-key <mode> <old_key> [new_key] <file>" >&2
              echo "Modes: replace, add, remove" >&2
              exit 1
            }

            if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
              usage
            fi

            mode="$1"
            old_key_path="$2"
            ssh_to_age_bin="$(command -v ssh-to-age)"
            if [ "$#" -eq 3 ]; then
              new_key_path=""
              file="$3"
            else
              new_key_path="$3"
              file="$4"
            fi

            case "$mode" in
              replace|add|remove)
                ;;
              *)
                usage
                ;;
            esac

            if [ "$mode" != "remove" ] && [ -z "$new_key_path" ]; then
              usage
            fi

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

            old_key_pub_path="$old_key_path.pub"
            if [ ! -f "$old_key_pub_path" ]; then
              echo "Missing SSH public key: $old_key_pub_path" >&2
              exit 1
            fi

            if [ "$mode" != "remove" ]; then
              new_key_pub_path="$new_key_path.pub"
              new_key_name="$(basename "$new_key_path")"
              new_key_name="$(printf "%s" "$new_key_name" | sed 's/\.pub$//')"
              if [ ! -f "$new_key_pub_path" ]; then
                echo "Missing SSH public key: $new_key_pub_path" >&2
                exit 1
              fi
            fi

            old_key="$(cat "$old_key_pub_path" | "$ssh_to_age_bin")"
            if [ "$mode" != "remove" ]; then
              new_key="$(cat "$new_key_pub_path" | "$ssh_to_age_bin")"
            fi
            if [ -r "$old_key_path" ]; then
              old_identity="$("$ssh_to_age_bin" -private-key -i "$old_key_path")"
            else
              old_identity="$(sudo "$ssh_to_age_bin" -private-key -i "$old_key_path")"
            fi

            if ! grep -Fq "$old_key" "$sops_yaml"; then
              echo "Old key not found in .sops.yaml" >&2
              exit 1
            fi

            if [ "$mode" != "remove" ]; then
              if grep -Fq "$new_key" "$sops_yaml"; then
                echo "New key already present in .sops.yaml" >&2
                exit 1
              fi
            fi

            tmp="$(mktemp)"
            case "$mode" in
              replace)
                if ! awk -v old="$old_key" -v new="$new_key" '
                  {
                    if (index($0, old)) {
                      gsub(old, new)
                      replaced = 1
                    }
                    print
                  }
                  END {
                    if (!replaced) {
                      exit 3
                    }
                  }
                ' "$sops_yaml" > "$tmp"; then
                  rm -f "$tmp"
                  echo "Failed to update .sops.yaml with new key" >&2
                  exit 1
                fi
                ;;
              add)
                if ! awk -v old="$old_key" -v new="$new_key" -v new_name="$new_key_name" '
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
                if ! awk -v old="$old_key" '
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
                  echo "Failed to remove old key from .sops.yaml" >&2
                  exit 1
                fi
                ;;
          esac

          mv "$tmp" "$sops_yaml"

          SOPS_AGE_KEY="$old_identity" \
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

  flake.modules.systemManager.base =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      config = lib.mkIf config.my.sops.enable {
        users.groups.keys = { };
      };
    };
}
