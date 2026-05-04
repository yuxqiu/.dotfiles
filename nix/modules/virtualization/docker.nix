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

  flake.modules.systemManager.docker =
    {
      nixosModulesPath,
      lib,
      ...
    }:
    {
      imports = [ (nixosModulesPath + "/virtualisation/docker.nix") ];
      options.networking.proxy.envVars = lib.mkOption {
        type = lib.types.attrs;
        internal = true;
        default = { };
        description = ''
          Environment variables used for the network proxy.
        '';
      };

      config = {
        virtualisation.docker.enable = true;
      };
    };
}
