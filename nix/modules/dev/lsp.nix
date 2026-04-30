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
        bash-language-server
        clang-tools
        deadnix
        golangci-lint
        gopls
        lua-language-server
        markdown-oxide
        nixd
        nixfmt
        package-version-server
        ruff
        rustup
        shellcheck
        statix
        taplo
        tectonic
        texlab
        (texliveSmall.withPackages (
          ps: with ps; [
            latexindent
            synctex
          ]
        ))
        tinymist
        tree-sitter
        typos-lsp
        uv
        vscode-langservers-extracted
        yaml-language-server
        yamllint
      ];
    };
}
