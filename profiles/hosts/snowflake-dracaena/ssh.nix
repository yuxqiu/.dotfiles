{
  flake.modules.nixos.snowflake-dracaena =
    { config, ... }:
    {
      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [
        config.my.user.keys."general-ssh"
      ];
    };
}
