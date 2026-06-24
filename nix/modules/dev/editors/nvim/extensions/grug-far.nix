{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.grug-far = {
      enable = true;
      lazyLoad.settings.lazy = true;
      settings = {
        headerMaxWidth = 80;
      };
    };

    programs.nixvim.keymaps = [
      {
        key = "<leader>sr";
        action.__raw = ''
          function()
            require('lz.n').trigger_load('grug-far.nvim')
            require("grug-far").open({ prefills = { filesFilter = "*." .. vim.fn.expand("%:e") } })
          end
        '';
        options.desc = "Search and replace (project)";
      }
      {
        key = "<leader>sr";
        mode = "v";
        action.__raw = ''
          function()
            require('lz.n').trigger_load('grug-far.nvim')
            require("grug-far").with_visual_selection({ prefills = { filesFilter = "*." .. vim.fn.expand("%:e") } })
          end
        '';
        options.desc = "Search and replace (project, selection)";
      }
      {
        key = "<leader>sR";
        action.__raw = ''
          function()
            require('lz.n').trigger_load('grug-far.nvim')
            require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
          end
        '';
        options.desc = "Search and replace (current file)";
      }
    ];

    programs.nixvim.autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [ "grug-far" ];
        callback.__raw = ''
          function(args)
            vim.keymap.set("n", "<C-w>", function()
              vim.api.nvim_buf_delete(0, {})
            end, {
              buffer = args.buf,
              desc = "Close grug-far buffer",
            })
          end
        '';
      }
    ];
  };
}
