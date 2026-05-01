{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = trouble-nvim;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        local function lazy_load(pack_name, before_fn, after_fn)
          if vim.fn.exists("g:loaded_" .. pack_name) == 0 then
            if before_fn then before_fn() end
            vim.cmd("packadd " .. pack_name)
            vim.g["loaded_" .. pack_name] = 1
            if after_fn then after_fn() end
          end
        end

        local function load_trouble()
          lazy_load("trouble.nvim", nil, function()
            require("trouble").setup({
              modes = {
                diagnostics = { auto_open = false },
                lsp = { win = { type = "split" } },
              },
            })
          end)
        end

        vim.keymap.set("n", "<leader>xx", function() load_trouble(); vim.cmd("Trouble diagnostics toggle") end, { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>xq", function() load_trouble(); vim.cmd("Trouble qflist toggle") end, { desc = "Quickfix list" })
      '';
    };
}
