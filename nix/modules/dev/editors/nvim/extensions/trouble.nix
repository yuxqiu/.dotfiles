{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.trouble = {
        enable = true;
        lazyLoad.settings.keys = [
          {
            __unkeyed-1 = "<leader>td";
            __unkeyed-2.__raw = ''
              function() vim.cmd("Trouble diagnostics toggle") end
            '';
            desc = "Diagnostics";
          }
          {
            __unkeyed-1 = "<leader>tq";
            __unkeyed-2.__raw = ''
              function() vim.cmd("Trouble qflist toggle") end
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
