{ nixGL, ... }:

{
  targets.genericLinux.nixGL = {
    # Set packages to nixGL.packages for non-NixOS, null for NixOS
    packages = if builtins.pathExists /etc/NIXOS then null else nixGL.packages;
    vulkan.enable = true; # Enable Vulkan
  };
}
