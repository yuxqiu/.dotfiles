{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.nvim-surround = {
      enable = true;
      settings = {
        move_cursor = false;
      };
    };

    programs.nixvim.autoCmd = [
      {
        event = [ "VimEnter" ];
        once = true;
        callback.__raw = ''
          function()
            vim.keymap.del("n", "yss")
          end
        '';
      }
    ];
  };
}
