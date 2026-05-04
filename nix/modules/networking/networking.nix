{
  flake.modules.systemManager.networking =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options = {
        networking.hosts = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          default = { };
          description = "Hosts entries to add to /etc/hosts";
        };
      };

      config = {
        networking.hosts = {
          "127.0.0.1" = [ "localhost" ];
          "::1" = [
            "localhost"
            "ip6-localhost"
            "ip6-loopback"
          ];
          "ff02::1" = [ "ip6-allnodes" ];
          "ff02::2" = [ "ip6-allrouters" ];
        };

        environment.etc.hosts = {
          source =
            let
              oneToString = set: ip: ip + " " + lib.concatStringsSep " " set.${ip} + "\n";
              allToString = set: lib.concatMapStrings (oneToString set) (lib.attrNames set);
            in
            pkgs.writeText "string-hosts" (
              allToString (lib.filterAttrs (_: v: v != [ ]) config.networking.hosts)
            );
        };
      };
    };
}
