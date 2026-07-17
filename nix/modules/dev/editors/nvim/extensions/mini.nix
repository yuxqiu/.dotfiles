{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.mini = {
      enable = true;
      modules.move = {
        mappings = {
          down = "<C-S-j>";
          up = "<C-S-k>";
          left = "<C-S-h>";
          right = "<C-S-l>";
          line_down = "<C-S-j>";
          line_up = "<C-S-k>";
          line_left = "<C-S-h>";
          line_right = "<C-S-l>";
        };
        options.reindent_linewise = true;
      };
      modules.cmdline = {
        autocomplete.predicate.__raw = ''
          function()
            return vim.fn.getcmdtype() == ":"
          end
        '';
      };
      modules.notify = { };
    };
  };
}
