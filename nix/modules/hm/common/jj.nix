{ ... }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "yuxqiu";
        email = "yuxqiu@proton.me";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519_proton.pub";
      };
    };
  };
}
