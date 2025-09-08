{ ... }:

{
  programs.git = {
    enable = true;

    userName = "yuxqiu";
    userEmail = "yuxqiu@proton.me";

    extraConfig = {
      user.signingkey = "~/.ssh/id_ed25519_proton.pub";
      core.excludesfile = "~/.gitignore_global";
      commit.gpgsign = true;

      gpg.format = "ssh";

      filter."lfs".clean = "git-lfs clean -- %f";
      filter."lfs".smudge = "git-lfs smudge -- %f";
      filter."lfs".process = "git-lfs filter-process";
      filter."lfs".required = true;

      init.defaultBranch = "main";

      alias.graph = "log --all --graph --decorate --oneline";
      alias.rank = "shortlog -s -n --no-merges";
      alias.fame = "!python -m gitfame";
      alias.info = "!onefetch";
      alias.dft = "!f() { GIT_EXTERNAL_DIFF=difft git diff $@; }; f";
      alias.uncommit = "!git reset --soft HEAD^ && git restore --staged .";

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
  };

  home.file."~/.gitignore_global".text = ''
    **/.DS_Store
    **/.idea
    **/target/
    **/__pycache__/
    **/.pytest_cache
    **/.dev
  '';
}
