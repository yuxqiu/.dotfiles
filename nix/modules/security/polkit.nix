{
  flake.modules.systemManager.base =
    { pkgs, ... }:
    {
      # Essential setup for Polkit integration in Nix apps on non-NixOS distributions.
      # Creates the expected setuid wrapper at /run/wrappers/bin.
      #
      # TODO: once polkit-agent-helper-1 is removed in host system and switch to socket-activated
      # `polkit-agent-helper`, this can be removed.
      security.wrappers = {
        polkit-agent-helper-1 = {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.polkit.out}/lib/polkit-1/polkit-agent-helper-1";
        };
      };
    };
}
