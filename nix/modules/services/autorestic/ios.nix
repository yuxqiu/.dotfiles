{
  flake.modules.systemManager.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      autoresticBin = "${pkgs.autorestic}/bin/autorestic -c ${
        config.sops.secrets."autorestic.yaml".path
      }";
      resticBin = "${pkgs.restic}/bin/restic";
      iosToolsPath = lib.makeBinPath [
        pkgs.fuse
        pkgs.ifuse
        pkgs.libimobiledevice
      ];

      # Must apply the weak config to pair with ios
      # - https://github.com/libimobiledevice/libimobiledevice/issues/1695
      autoresticIosBin = pkgs.writeShellScriptBin "autorestic-ios" ''
                set -euo pipefail

                if [ -z "''${HOME:-}" ]; then
                  echo "HOME is not set" >&2
                  exit 1
                fi

                export PATH="${iosToolsPath}:$PATH"

                ios_root="$HOME/iPhone"
                ios_mount="$ios_root/iPhone"
                chat_mount="$ios_root/Chat"
                conf_file="$ios_root/openssl-weak.conf"

                mkdir -p "$ios_root" "$ios_mount" "$chat_mount"

                cat > "$conf_file" <<'EOF'
        .include /etc/ssl/openssl.cnf
        [openssl_init]
        alg_section = evp_properties
        [evp_properties]
        rh-allow-sha1-signatures = yes
        EOF

                OPENSSL_CONF="$conf_file" idevicepair pair
                ifuse "$ios_mount" -o allow_root
                ifuse --documents com.readdle.ReaddleDocsIPad "$chat_mount" -o allow_root

                sudo ${autoresticBin} --restic-bin ${resticBin} backup --verbose -l ios

                fusermount -u "$ios_mount"
                fusermount -u "$chat_mount"
      '';
    in
    {
      config = lib.mkIf config.my.sops.enable {
        environment.systemPackages = with pkgs; [
          autoresticIosBin
          fuse
          ifuse
          libimobiledevice
        ];

        # for fuse to work
        environment.etc = {
          "fuse.conf" = {
            text = ''
              user_allow_other
            '';
            replaceExisting = true;
          };
        };
        security.wrappers = {
          fusermount = {
            setuid = true;
            owner = "root";
            group = "root";
            source = "${pkgs.fuse}/bin/fusermount";
          };
        };
      };
    };
}
