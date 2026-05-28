{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      agent-lsp = pkgs.callPackage (inputs.self + /packages/agent-lsp.nix) { };
    in
    {
      home.packages = [ agent-lsp ];

      programs.mcp = {
        enable = true;
        servers.lsp = {
          command = "agent-lsp";
          args = [
            "bash:bash-language-server,--stdio"
            "c:clangd"
            "cpp:clangd"
            "go:gopls"
            "json:vscode-json-language-server,--stdio"
            "latex:texlab"
            "lua:lua-language-server"
            "markdown:markdown-oxide"
            "nix:nixd,--stdio"
            "python:basedpyright,--stdio"
            "rust:rust-analyzer"
            "toml:taplo,--stdio"
            "typescript:typescript-language-server,--stdio"
            "typst:tinymist"
            "yaml:yaml-language-server,--stdio"
          ];
        };
      };
    };
}
