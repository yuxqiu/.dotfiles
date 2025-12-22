{ config, ... }:
{
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
        key = config.keys.githubPub;
      };
    };
  };
}
