{
  flake.modules.nixos.yuxqiu-cedrus = {
    sops = {
      defaultSopsFile = ../../secrets/yuxqiu.yaml;
      age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
      age.generateKey = true;
    };
  };
}
