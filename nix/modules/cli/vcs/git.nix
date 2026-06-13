{
  flake.modules.homeManager.git =
    { config, pkgs, ... }:
    {
      programs.git = {
        enable = true;

        settings = {
          user.name = "yuxqiu";
          user.email = "yuxqiu@proton.me";

          init.defaultBranch = "main";

          branch.sort = "-committerdate";
          tag.sort = "version:refname";

          commit.verbose = true;
          help.autocorrect = "prompt";

          alias = {
            graph = "log --all --graph --decorate --oneline";
            rank = "shortlog -s -n --no-merges";
            fame = "!gitfame";
            info = "!onefetch";
            uncommit = ''
              !f() {
                if git rev-parse --verify HEAD^ >/dev/null 2>&1; then
                  git reset --soft HEAD^;
                else
                  git update-ref -d HEAD;
                fi;
              }; f
            '';
          };

          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
          };

          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };

          filter = {
            "lfs".clean = "git-lfs clean -- %f";
            "lfs".smudge = "git-lfs smudge -- %f";
            "lfs".process = "git-lfs filter-process";
            "lfs".required = true;
          };

          pull = {
            rebase = true;
          };

          push = {
            autoSetupRemote = true;
            followTags = true;
          };

          rebase = {
            autoStash = true;
          };
        };

        signing = {
          key = config.my.user.keys."github-sign";
          format = "ssh";
          signByDefault = true;
        };

        ignores = [
          "**/.DS_Store"
          "**/.idea"
          "**/target/"
          "**/__pycache__/"
          "**/.pytest_cache"
          "**/.dev"
          "**/.logs"
        ];
      };

      programs.zsh.shellAliases = {
        guc = "git uncommit";
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };

      home.packages = with pkgs; [
        git-cliff
        git-crypt
        git-lfs
        (pkgs.symlinkJoin {
          name = "git-fame"; # Customize this name
          paths = [ pkgs.git-fame ]; # The original package
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/git-fame \
              --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}
          '';
        })
        onefetch
      ];
    };
}
