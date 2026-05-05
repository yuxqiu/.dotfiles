{
  flake.modules.homeManager.nvim = {
    programs.neovim.initLua = ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typst", "tex", "latex", "markdown" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
        end,
      })
    '';
  };
}
