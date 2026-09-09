{
  flake.modules.homeManager.c =
    { pkgs, ... }:
    {
      my.dev.languages.c = {
        toolchain = with pkgs; [
          clang
          cmake
        ];
        lsp = [ pkgs.clang-tools ];
        formatter = pkgs.clang-tools;
        linter = [ pkgs.clang-tools ];
      };
    };
}
