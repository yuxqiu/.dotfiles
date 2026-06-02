{
  flake.modules.homeManager.zsh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = ''
          fpath+=("${config.home.profileDirectory}/share/zsh/site-functions" /run/current-system/sw/share/zsh/site-functions /run/current-system/sw/share/zsh/vendor-completions)
          ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
        '';

        # Enable Oh My Zsh
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "colored-man-pages"
            "z"
            "dirhistory"
            "jj"
          ];
          theme = "robbyrussell";
        };

        # Aliases
        shellAliases = lib.mkMerge [
          { sudo = "sudo "; }
          (lib.mkIf pkgs.stdenv.isLinux { open = "${pkgs.xdg-utils}/bin/xdg-open"; })
        ];

        siteFunctions = {
          gc-pip = ''
            for pkg in $(python3 -m pip list --not-required --format=freeze 2>/dev/null | cut -d= -f1 | tail -n +3); do
                echo -n "Removing $pkg ... " ;
                python3 -m pip uninstall -y "$pkg" >/dev/null 2>&1 && echo "removed" || echo "skipped (protected or undeletable)";
            done
          '';
          gc-kondo = "${pkgs.kondo}/bin/kondo";
          gc-nix = "nix-collect-garbage -d";
          gc-hm = ''
            home-manager expire-generations now
            gc-nix
          '';
          gc-nixos = ''
            sudo nix-env --delete-generations now -p /nix/var/nix/profiles/system
            gc-nix
          '';
          gc-cache = "${pkgs.bleachbit}/bin/bleachbit";

          nr = ''
            if [ $# -eq 0 ]; then
              echo "Usage: nr <flake-output-name>"
              echo "Example: nr yuxqiu-cedrus"
              return 1
            fi
            nix-update-git -u . --rules all
            nix flake update
            sudo nixos-rebuild switch --flake ".#$1"
          '';
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          jdks = "/usr/libexec/java_home -V";

          jdk = ''
            version=$1
            export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
            java -version
          '';
        };
      };

      # oh-my-zsh clipboard plugin dependencies (Linux only)
      home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.wl-clipboard ];
    };
}
