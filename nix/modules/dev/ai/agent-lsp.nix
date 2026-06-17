{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, config, ... }:
    let
      agent-lsp = pkgs.callPackage (inputs.self + /packages/agent-lsp.nix) { };
    in
    {
      home.packages = [
        agent-lsp
      ]
      ++ config.my.dev.lsp;

      programs.mcp.servers.lsp = {
        command = "agent-lsp";
        args = [
          "bash:bash-language-server,start"
          "c:clangd"
          "cpp:clangd"
          "go:gopls"
          "json:vscode-json-language-server,--stdio"
          "latex:texlab"
          "lua:lua-language-server"
          "markdown:markdown-oxide"
          "nix:nixd"
          "python:basedpyright-langserver,--stdio"
          "rust:rust-analyzer"
          "toml:taplo,lsp,stdio"
          "typescript:typescript-language-server,--stdio"
          "typst:tinymist,lsp"
          "yaml:yaml-language-server,--stdio"
        ];
      };
    };
}
