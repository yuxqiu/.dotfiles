{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.trouble = {
      enable = true;
      lazyLoad.settings.lazy = true;
      settings = {
        modes = {
          diagnostics.auto_open = false;
          lsp.win.type = "split";
        };
      };
    };

    programs.nixvim.keymaps = [
      {
        key = "<leader>td";
        action.__raw = ''
          function()
            require('lz.n').trigger_load('trouble.nvim')
            vim.cmd("Trouble diagnostics toggle")
          end
        '';
        options.desc = "Diagnostics";
      }
      {
        key = "<leader>tq";
        action.__raw = ''
          function()
            require('lz.n').trigger_load('trouble.nvim')
            vim.cmd("Trouble qflist toggle")
          end
        '';
        options.desc = "Quickfix list";
      }
    ];
  };
}
