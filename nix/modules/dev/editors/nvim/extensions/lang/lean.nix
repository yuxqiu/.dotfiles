{
  flake.modules.homeManager.nvim =
    {
      config,
      lib,
      ...
    }:
    lib.mkIf (config.my.dev.languages ? lean) {
      programs.nixvim.plugins.lean = {
        enable = true;
        settings = {
          mappings = true;
          lsp.enable = true;
        };
      };
      # Append (not prepend) the nix lean4 package to PATH so elan —
      # which respects each project's lean-toolchain pin — takes
      # precedence. lean4 remains available as a fallback for standalone files.
      programs.nixvim.dependencies.lean.packageFallback = true;
    };
}
