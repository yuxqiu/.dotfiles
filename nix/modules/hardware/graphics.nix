{ inputs, ... }:
{
  flake.modules.systemManager.graphics = {
    imports = [ inputs.nix-system-graphics.systemModules.default ];
    system-graphics.enable = true;
  };
}
