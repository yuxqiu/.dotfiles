{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.dropbar = {
      enable = true;
      # Render breadcrumbs in the winbar (top of each window, under bufferline).
      # LSP -> treesitter fallback; clickable dropdown menus per segment.
      settings.sources.path.preview = false;
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
