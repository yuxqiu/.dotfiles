{
  flake.modules.homeManager.codeisland =
    { pkgs, ... }:
    let
      codeislandSrc = pkgs.fetchFromGitHub {
        owner = "payprays";
        repo = "codeIsland-dms";
        rev = "f6143cecc61c5edd9c31bf4862ce48423fbdc975"; # follow:branch main
        hash = "sha256-yoLScXCx66ZD7iQEgCmmwVy75qVph0Gfsfdcum6dLSo=";
      };

      codeisland-linux = pkgs.python3.pkgs.buildPythonPackage {
        pname = "codeisland-linux";
        version = "0.1.0";
        pyproject = false;
        src = "${codeislandSrc}/linux-skeleton";
        installPhase = ''
          runHook preInstall
          mkdir -p $out/${pkgs.python3.sitePackages}
          cp -r codeisland_linux $out/${pkgs.python3.sitePackages}/
          runHook postInstall
        '';
      };

      codeislandPython = pkgs.python3.withPackages (_: [ codeisland-linux ]);
    in
    {
      programs.dank-material-shell.plugins.codeIsland = {
        enable = true;
        settings = {
          boardHeight = 420;
          boardWidth = 620;
          defaultViewMode = "active";
        };
      };

      home.packages = [ codeislandPython ];

      programs.opencode.settings.plugin = [
        "${codeislandSrc}/linux-skeleton/codeisland_linux/resources/codeisland-opencode-linux.js"
      ];

      systemd.user.services.codeislandd = {
        Unit = {
          Description = "CodeIsland session daemon";
          After = [ "default.target" ];
        };

        Service = {
          ExecStart = "${codeislandPython}/bin/python -m codeisland_linux.server";
          Restart = "on-failure";
          RestartSec = 2;
        };

        Install.WantedBy = [ "default.target" ];
      };
    };
}
