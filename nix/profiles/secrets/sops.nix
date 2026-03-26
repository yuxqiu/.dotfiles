{ inputs, lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      sops-update = pkgs.writeShellScriptBin "sops-update" ''
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

        if [ -r "$key_path" ]; then
          age_key="$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$key_path")"
        else
          age_key="$(sudo ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$key_path")"
        fi
        SOPS_AGE_KEY="$age_key" \
          EDITOR="${pkgs.neovim}/bin/nvim" \
          ${pkgs.sops}/bin/sops "$file"
      '';

      sops-update-key = pkgs.writeShellScriptBin "sops-update-key" ''
        set -euo pipefail

        usage() {
          echo "Usage: sops-update-key <old_key> <new_key> <file>" >&2
          exit 1
        }

        if [ "$#" -ne 3 ]; then
          usage
        fi

        old_key_path="$1"
        new_key_path="$2"
        file="$3"

        find_sops_root() {
          if [ -f ".sops.yaml" ]; then
            ${pkgs.coreutils}/bin/pwd
            return 0
          fi

          if ${pkgs.git}/bin/git rev-parse --show-toplevel >/dev/null 2>&1; then
            root="$(${pkgs.git}/bin/git rev-parse --show-toplevel)"
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
        new_key_pub_path="$new_key_path.pub"

        if [ ! -f "$old_key_pub_path" ]; then
          echo "Missing SSH public key: $old_key_pub_path" >&2
          exit 1
        fi

        if [ ! -f "$new_key_pub_path" ]; then
          echo "Missing SSH public key: $new_key_pub_path" >&2
          exit 1
        fi

        old_key="$(${pkgs.coreutils}/bin/cat "$old_key_pub_path" | ${pkgs.ssh-to-age}/bin/ssh-to-age)"
        new_key="$(${pkgs.coreutils}/bin/cat "$new_key_pub_path" | ${pkgs.ssh-to-age}/bin/ssh-to-age)"
        if [ -r "$old_key_path" ]; then
          old_identity="$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$old_key_path")"
        else
          old_identity="$(sudo ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$old_key_path")"
        fi

        if ! ${pkgs.gnugrep}/bin/grep -Fq "$old_key" "$sops_yaml"; then
          echo "Old key not found in .sops.yaml" >&2
          exit 1
        fi

        if ${pkgs.gnugrep}/bin/grep -Fq "$new_key" "$sops_yaml"; then
          echo "New key already present in .sops.yaml" >&2
          exit 1
        fi

        tmp="$(${pkgs.coreutils}/bin/mktemp)"
        if ! ${pkgs.gawk}/bin/awk -v old="$old_key" -v new="$new_key" '
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
          ${pkgs.coreutils}/bin/rm -f "$tmp"
          echo "Failed to update .sops.yaml with new key" >&2
          exit 1
        fi

        ${pkgs.coreutils}/bin/mv "$tmp" "$sops_yaml"

        SOPS_AGE_KEY="$old_identity" \
          ${pkgs.sops}/bin/sops updatekeys "$file"
      '';
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
