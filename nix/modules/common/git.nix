{ ... }:

{
  programs.git = {
    enable = true;

    userName = "yuxqiu";
    userEmail = "yuxqiu@proton.me";

    aliases = {
      graph = "log --all --graph --decorate --oneline";
      rank = "shortlog -s -n --no-merges";
      fame = "!gitfame";
      info = "!onefetch";
      uncommit = "!git reset --soft HEAD^ && git restore --staged .";
    };

    signing = {
      key = "~/.ssh/id_ed25519_proton.pub";
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
    ];

    extraConfig = {
      filter."lfs".clean = "git-lfs clean -- %f";
      filter."lfs".smudge = "git-lfs smudge -- %f";
      filter."lfs".process = "git-lfs filter-process";
      filter."lfs".required = true;

      init.defaultBranch = "main";

      branch.sort = "-committerdate";
      tag.sort = "version:refname";

      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;

      push.autoSetupRemote = true;
      push.followTags = true;

      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;

      help.autocorrect = "prompt";
      commit.verbose = true;
    };

    delta.enable = true;
  };
}
