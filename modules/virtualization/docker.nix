{
  flake.modules.homeManager.docker =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ lazydocker ];

      programs.zsh = {
        shellAliases = {
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
        };

        siteFunctions = {
          docksh = ''
            docker exec -it $1 /bin/bash
          '';
        };
      };
    };

  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
  };
}
