{
  flake.modules.homeManager.nvim = {
    programs.nixvim = {
      plugins.ts-context-commentstring = {
        enable = true;
        settings.enable_autocmd = false;
      };

      plugins.comment = {
        enable = true;
        settings = {
          padding = true;
          sticky = true;
          pre_hook.__raw = "require('ts_context_commentstring.utils').get_cs";
          opleader.line = "gc";
        };
      };

      keymaps = [
        {
          key = "<C-/>";
          mode = "n";
          action = "<Plug>(comment_toggle_linewise_current)";
          options.desc = "Toggle comment";
        }
        {
          key = "<C-/>";
          mode = "v";
          action = "<Plug>(comment_toggle_linewise_visual)";
          options.desc = "Toggle comment";
        }
        {
          key = "<C-/>";
          mode = "i";
          action = "<Esc><Plug>(comment_toggle_linewise_current)A";
          options.desc = "Toggle comment";
        }
      ];
    };
  };
}
