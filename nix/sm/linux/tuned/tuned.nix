{ ... }:
{
  environment = {
    etc = {
      "tuned/tuned-main.conf".source = ./tuned-main.conf;
    };
  };
}
