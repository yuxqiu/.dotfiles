{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = undotree;
          type = "lua";
          config = ''
            vim.g.undotree_WindowLayout = 4
            vim.g.undotree_ShortIndel = 1

            vim.keymap.set("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undotree" })
          '';
        }
      ];
    };
}
