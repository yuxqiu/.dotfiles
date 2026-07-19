{
  flake.modules.homeManager.nvim = {
    # Save dropbar's original default `bar.enable` before nixvim calls
    # setup(), so our override can delegate to it without infinite recursion.
    programs.nixvim.extraConfigLuaPre = ''
      _G._dropbar_orig_bar_enable = require("dropbar.configs").opts.bar.enable
    '';

    programs.nixvim.plugins.dropbar = {
      enable = true;
      # Render breadcrumbs in the winbar (top of each window, under bufferline).
      # LSP -> treesitter fallback; clickable dropdown menus per segment.
      settings.sources.path.preview = false;
      # Exclude terminal buffers — dropbar's default returns true for
      # `buftype == "terminal"`, overriding snacks.terminal's `winbar = ""`.
      settings.bar.enable.__raw = ''
        function(buf, win, info)
          if vim.bo[buf].buftype == "terminal" then
            return false
          end
          return _G._dropbar_orig_bar_enable(buf, win, info)
        end
      '';
    };

    programs.nixvim.keymaps = [
      {
        mode = "n";
        key = "<leader>;";
        action.__raw = ''require("dropbar.api").pick'';
        options.desc = "Pick symbol in winbar";
      }
      {
        mode = "n";
        key = "[;";
        action.__raw = ''require("dropbar.api").goto_context_start'';
        options.desc = "Go to start of current context";
      }
      {
        mode = "n";
        key = "];";
        action.__raw = ''require("dropbar.api").select_next_context'';
        options.desc = "Select next context";
      }
    ];
  };
}
