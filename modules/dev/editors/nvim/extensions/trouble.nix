{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.trouble = {
      enable = true;
      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "<leader>td";
          __unkeyed-2.__raw = ''
            function()
              require("trouble").open("diagnostics")
            end
          '';
          desc = "Diagnostics";
        }
        {
          __unkeyed-1 = "<leader>tq";
          __unkeyed-2.__raw = ''
            function()
              require("trouble").open("qflist")
            end
          '';
          desc = "Quickfix list";
        }
      ];
      settings = {
        modes = {
          diagnostics.auto_open = false;
          lsp.win.type = "split";
        };
      };
    };
  };
}
