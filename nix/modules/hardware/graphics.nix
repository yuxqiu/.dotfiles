{ inputs, ... }:
{
  flake.modules.systemManager.desktop = {
    imports = [ inputs.nix-system-graphics.systemModules.default ];
    system-graphics.enable = true;
  };
}
