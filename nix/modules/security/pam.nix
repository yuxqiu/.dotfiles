{
  flake.modules.systemManager.base =
    { pkgs, ... }:
    {
      # Setup PAM unix_chkpwd helper on non-NixOS distributions.
      # Creates the expected setuid wrapper at /run/wrappers/bin/unix_chkpwd.
      #
      # https://github.com/nix-community/home-manager/issues/7027
      security.wrappers = {
        unix_chkpwd = {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.pam}/bin/unix_chkpwd";
        };
      };
    };
}
