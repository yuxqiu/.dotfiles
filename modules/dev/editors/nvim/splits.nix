{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPlugins = [ pkgs.vimPlugins.winshift-nvim ];

        keymaps = [
          # --- Navigation
          {
            mode = "n";
            key = "<leader>wh";
            action = "<C-w>h";
            options.desc = "Focus left split";
          }
          {
            mode = "n";
            key = "<leader>wj";
            action = "<C-w>j";
            options.desc = "Focus below split";
          }
          {
            mode = "n";
            key = "<leader>wk";
            action = "<C-w>k";
            options.desc = "Focus above split";
          }
          {
            mode = "n";
            key = "<leader>wl";
            action = "<C-w>l";
            options.desc = "Focus right split";
          }

          # --- Sticky resize mode
          {
            mode = "n";
            key = "<leader>wr";
            action.__raw = ''
              function()
                vim.notify("[RESIZE] h/j/k/l: resize  Esc: exit", vim.log.levels.INFO)
                local actions = {
                  ["h"]      = "vertical resize -3",
                  ["j"]      = "resize -3",
                  ["k"]      = "resize +3",
                  ["l"]      = "vertical resize +3",
                  ["\x1b[D"] = "vertical resize -3",
                  ["\x1b[B"] = "resize -3",
                  ["\x1b[A"] = "resize +3",
                  ["\x1b[C"] = "vertical resize +3",
                }
                while true do
                  local ok, c = pcall(vim.fn.getcharstr)
                  if not ok then break end
                  if c == "\27" or c == "q" then break end
                  if actions[c] then vim.cmd(actions[c]) end
                  vim.cmd("redraw!")
                end
              end
            '';
            options.desc = "Sticky resize mode";
          }

          # --- Split management
          {
            mode = "n";
            key = "<leader>wv";
            action = "<cmd>vsplit<CR>";
            options.desc = "Split vertically";
          }
          {
            mode = "n";
            key = "<leader>w-";
            action = "<cmd>split<CR>";
            options.desc = "Split horizontally";
          }
          {
            mode = "n";
            key = "<leader>wc";
            action = "<cmd>close<CR>";
            options.desc = "Close split";
          }
          {
            mode = "n";
            key = "<leader>wo";
            action = "<cmd>only<CR>";
            options.desc = "Close other splits";
          }

          # --- WinShift: move mode
          {
            mode = "n";
            key = "<leader>wm";
            action = "<cmd>WinShift<CR>";
            options.desc = "WinShift move mode";
          }
          # --- WinShift: swap window
          {
            mode = "n";
            key = "<leader>ws";
            action = "<cmd>WinShift swap<CR>";
            options.desc = "WinShift swap window";
          }
        ];

        extraConfigLua = ''
          require("winshift").setup()
        '';
      };
    };
}
