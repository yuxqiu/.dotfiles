{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.undotree = {
      enable = true;
      settings = {
        WindowLayout = 4;
        ShortIndel = 1;
      };
    };

    programs.nixvim.extraConfigLua = ''
      vim.keymap.set("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undotree" })
    '';
  };
}
