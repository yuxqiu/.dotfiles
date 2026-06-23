{
  flake.modules.homeManager.c =
    { pkgs, ... }:
    {
      my.dev.languages.c = {
        toolchain = with pkgs; [ clang cmake ];
        lsp = [
          {
            server = "clangd";
            package = pkgs.clang-tools;
            binary = "clangd";
            filetypes = [ "c" "cpp" ];
          }
        ];
        treesitter = [ "c" "cpp" ];
      };
    };
}
