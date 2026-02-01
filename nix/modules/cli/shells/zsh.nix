{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

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
        shellAliases = {
          # Sudo with trailing space
          sudo = "sudo ";

          # Docker
          dockps = ''docker ps --format "{{.ID}} {{.Names}}"'';
          docklsc = "docker ps -a";
          dockrmc = "docker rm";
          docklsi = "docker images -a";
          dockrmi = "docker rmi";

          # Docker Compose
          dcbuild = "docker-compose build";
          dcup = "docker-compose up";
          dcdown = "docker-compose down";

          # Immortal ssh
          sshx = ''mosh "$@" -- screen -s -/bin/bash -qRRUS "mosh-''${HOSTNAME}"'';
        };

        siteFunctions = {
          docksh = ''
            docker exec -it $1 /bin/bash
          '';

          gc-pip = ''
            for pkg in $(python3 -m pip list --not-required --format=freeze 2>/dev/null | cut -d= -f1 | tail -n +3); do
                echo -n "Removing $pkg ... " ;
                python3 -m pip uninstall -y "$pkg" >/dev/null 2>&1 && echo "removed" || echo "skipped (protected or undeletable)";
            done
          '';
          gc-kondo = "${pkgs.kondo}/bin/kondo";
          gc-nix = "nix-collect-garbage";
          gc-hm = ''
            home-manager expire-generations now
            gc-nix
          '';
          gc-cache = "${pkgs.bleachbit}/bin/bleachbit";

          # Home Manager Update
          hm = ''
            if [ $# -eq 0 ]; then
              echo "Usage: hm <flake-output-name>"
              echo "Example: hm yuxqiu@laptop"
              return 1
            fi
            nix flake update
            update-nix-fetchgit */**/*.nix
            home-manager switch --flake ".#$1"
          '';
        };
      };
    };

  flake.modules.homeManager.darwin-base = {
    programs.zsh = {
      shellAliases = {
        # JDK
        jdks = "/usr/libexec/java_home -V";
      };

      siteFunctions = {
        jdk = ''
          version=$1
          export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
          java -version
        '';
      };
    };
  };

  flake.modules.homeManager.linux-base =
    { pkgs, ... }:
    {
      programs.zsh = {
        shellAliases = {
          # Open
          open = "xdg-open";
        };

        siteFunctions = {
          gc-dnf = ''
            sudo dnf autoremove
            sudo dnf clean all
          '';
          gc-sm = ''
            sudo $(which nix-env) --delete-generations old --profile /nix/var/nix/profiles/system-manager-profiles/system-manager
            gc-nix
          '';

          # System Manager Update
          sm = ''
            if [ $# -eq 0 ]; then
              echo "Usage: sm <flake-output-name>"
              echo "Example: sm '\"yuxqiu@laptop\"'"
              return 1
            fi
            nix flake update
            update-nix-fetchgit */**/*.nix
            system-manager switch --flake ".#$1" --sudo && rm result
          '';
        };
      };

      # oh-my-zsh clipboard plugin dependencies
      home.packages = [ pkgs.wl-clipboard ];
    };
}
