{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.treesitter = {
        enable = true;
        grammarPackages = [
          pkgs.vimPlugins.nvim-treesitter-parsers.vim
          pkgs.vimPlugins.nvim-treesitter-parsers.vimdoc
        ];
        settings = {
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };
      };
    };
}
