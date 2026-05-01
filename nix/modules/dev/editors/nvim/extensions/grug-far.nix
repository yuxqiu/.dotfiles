{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = grug-far-nvim;
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

        local function load_grug_far()
          lazy_load("grug-far.nvim", nil, function()
            require("grug-far").setup({ headerMaxWidth = 80 })
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
