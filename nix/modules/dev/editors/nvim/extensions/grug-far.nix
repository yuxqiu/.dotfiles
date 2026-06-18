{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = grug-far-nvim;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        local function load_grug_far()
          lazy_load("grug-far.nvim", nil, function()
            require("grug-far").setup({ headerMaxWidth = 80 })
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "grug-far",
              callback = function(args)
                vim.keymap.set("n", "<C-w>", function()
                  vim.api.nvim_buf_delete(0, {})
                end, {
                  buffer = args.buf,
                  desc = "Close grug-far buffer",
                })
              end,
            })
          end)
        end

        vim.keymap.set("n", "<leader>sr", function()
          load_grug_far()
          require("grug-far").open({ prefills = { filesFilter = "*." .. vim.fn.expand("%:e") } })
        end, { desc = "Search and replace (project)" })
        vim.keymap.set("v", "<leader>sr", function()
          load_grug_far()
          require("grug-far").with_visual_selection({ prefills = { filesFilter = "*." .. vim.fn.expand("%:e") } })
        end, { desc = "Search and replace (project, selection)" })
        vim.keymap.set("n", "<leader>sR", function()
          load_grug_far()
          require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
        end, { desc = "Search and replace (current file)" })
      '';
    };
}
