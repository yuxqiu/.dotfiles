{
  flake.modules.systemManager.base = {
    # don't bother managing nix
    nix = {
      enable = false;
    };

    system-manager.allowAnyDistro = true;
  };
}
