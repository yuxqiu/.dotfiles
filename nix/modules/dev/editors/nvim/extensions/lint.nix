{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.lint = {
      enable = true;
      luaConfig.post = ''
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            _G.debounce("lint:" .. vim.api.nvim_buf_get_name(0), 500, function()
              require("lint").try_lint()
            end)
          end,
        })

        vim.api.nvim_create_autocmd({ "CursorHold" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      '';
    };
  };
}
