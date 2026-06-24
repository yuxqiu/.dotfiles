{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.nvim-surround = {
      enable = true;
      settings = {
        move_cursor = false;
      };
    };

    programs.nixvim.extraConfigLua = ''
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function() vim.keymap.del("n", "yss") end,
      })
    '';
  };
}
