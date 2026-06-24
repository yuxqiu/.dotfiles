{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.lint.enable = true;

    programs.nixvim.autoCmd = [
      {
        event = [ "BufWritePost" ];
        callback.__raw = ''
          function()
            _G.debounce("lint:" .. vim.api.nvim_buf_get_name(0), 500, function()
              require("lint").try_lint()
            end)
          end
        '';
      }
      {
        event = [ "CursorHold" ];
        callback.__raw = ''
          function()
            require("lint").try_lint()
          end
        '';
      }
    ];
  };
}
