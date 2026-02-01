{ inputs, ... }:
{
  flake.modules.systemManager.gui = {
    imports = [ inputs.nix-system-graphics.systemModules.default ];
    system-graphics.enable = true;
  };
}
