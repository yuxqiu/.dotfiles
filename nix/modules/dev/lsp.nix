{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    {
      options.my.dev.lsp = lib.mkOption {
        type = lib.types.listOf lib.types.package;
      };

      # Ref
      # - https://github.com/zed-industries/zed/tree/main/crates/languages/src
      config.my.dev.lsp = with pkgs; [
        basedpyright
        clang-tools
        gopls
        markdown-oxide
        nixd
        nixfmt
        package-version-server
        vscode-json-languageserver
        ruff
        tectonic
        texlab
        (texliveSmall.withPackages (
          ps: with ps; [
            latexindent
            synctex
          ]
        ))
        typos-lsp
        tinymist
        uv
      ];
    };
}
