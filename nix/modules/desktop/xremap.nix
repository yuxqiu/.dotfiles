{ inputs, ... }:
{
  flake.modules.nixos.xremap =
    { ... }:
    {
      imports = [ inputs.xremap.nixosModules.default ];

      services.xremap = {
        enable = true;
        serviceMode = "user";
        withNiri = true;
      };
    };
}
