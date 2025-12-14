{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Enable Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "z" "dirhistory" "jj" ];
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

      # Home Manager Update
      home-manager-update =
        "nix flake update && update-nix-fetchgit modules/**/*.nix && home-manager switch --flake .#${pkgs.stdenv.system}";

      # Immortal ssh
      sshx = ''mosh "$@" -- screen -s -/bin/bash -qRRUS "mosh-''${HOSTNAME}"'';
    };

    # Environment variables
    sessionVariables = {
      # Python auto-complete
      PYTHONSTARTUP = "${config.home.homeDirectory}/.pythonrc";

      # Do Not Track
      DO_NOT_TRACK = "1";

      # Extend PATH
      PATH = "${config.home.homeDirectory}/.local/bin:$PATH";
    };

    siteFunctions = {
      docksh = ''
        docker exec -it $1 /bin/bash
      '';

      checksum = ''
        s=$(curl -fsSL "$1")
        if ! command -v shasum >/dev/null
        then
          shasum() { sha1sum "$@"; }
        fi
        c=$(printf %s\\n "$s" | shasum | awk '{print $1}')
        if [ "$c" = "$2" ]
        then
          printf %s\\n "$s"
        else
          echo "invalid checksum $c != $2" 1>&2
        fi
        unset s
        unset c
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
    };
  };
}
