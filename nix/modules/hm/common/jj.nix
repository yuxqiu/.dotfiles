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
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ppGOXp373SKeaGMKSfhQVVfvGIgpXXXcnnLDQ14hT yuxqiu@proton.me";
      };
    };
  };
}
