{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.grug-far = {
      enable = true;
      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "<leader>sr";
          __unkeyed-2.__raw = ''
            function()
              require("grug-far").open({ prefills = { filesFilter = "*." .. vim.fn.expand("%:e") } })
            end
          '';
          desc = "Search and replace (project)";
        }
        {
          __unkeyed-1 = "<leader>sr";
          __unkeyed-2.__raw = ''
            function()
              require("grug-far").with_visual_selection({ prefills = { filesFilter = "*." .. vim.fn.expand("%:e") } })
            end
          '';
          desc = "Search and replace (project, selection)";
          mode = "v";
        }
        {
          __unkeyed-1 = "<leader>sR";
          __unkeyed-2.__raw = ''
            function()
              require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
            end
          '';
          desc = "Search and replace (current file)";
        }
      ];
      settings = {
        headerMaxWidth = 80;
      };
    };

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
