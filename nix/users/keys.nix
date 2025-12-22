{ lib, ... }:
{
  options = {
    keys = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "My personal public keys";
    };
  };

  config = {
    keys = {
      githubPub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ppGOXp373SKeaGMKSfhQVVfvGIgpXXXcnnLDQ14hT yuxqiu@proton.me";
    };
  };
}
