{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-surround;
          type = "lua";
          config = ''
            require("nvim-surround").setup({
              move_cursor = false,
            })

            vim.api.nvim_create_autocmd("VimEnter", {
              once = true,
              callback = function() vim.keymap.del("n", "yss") end,
            })
          '';
        }
      ];
    };
}
