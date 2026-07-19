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
      modules.surround = { };
      modules.ai = {
        # Use uppercase second char for next/last to avoid conflict with
        # neovim 0.12 builtin incremental selection (an/in).
        mappings.around_next = "aN";
        mappings.inside_next = "iN";
        mappings.around_last = "aL";
        mappings.inside_last = "iL";
        n_lines = 500;
      };
      modules.notify = { };
    };
  };
}
