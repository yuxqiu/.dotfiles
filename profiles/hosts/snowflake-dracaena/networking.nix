{
  flake.modules.nixos.snowflake-dracaena = {
    networking.hostName = "snowflake";
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
