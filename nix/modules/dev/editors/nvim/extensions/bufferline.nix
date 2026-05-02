{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = bufferline-nvim;
          type = "lua";
          config = ''
            _G.smart_close = function(bufnr)
              bufnr = tonumber(bufnr) or vim.api.nvim_get_current_buf()
              local non_floating_wins = vim.tbl_filter(function(w)
                return not vim.api.nvim_win_get_config(w).zindex
              end, vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()))
              local in_split = #non_floating_wins > 1
              if vim.bo[bufnr].modified then
                local choice = vim.fn.confirm("Save changes?", "&Save\n&Discard\n&Cancel", 1)
                if choice == 1 then
                  vim.cmd("write")
                elseif choice == 2 then
                  vim.bo[bufnr].modified = false
                else
                  return
                end
              end
              local listed = vim.tbl_filter(function(b)
                return vim.bo[b].buflisted and b ~= bufnr
              end, vim.api.nvim_list_bufs())
              if #listed == 0 then
                vim.cmd("new")
                vim.cmd("bdelete! " .. bufnr)
              else
                vim.cmd("buffer " .. listed[#listed])
                vim.cmd("bdelete! " .. bufnr)
              end
              if in_split then
                vim.cmd("close")
              end
            end

            require("bufferline").setup({
              options = {
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = true,
                show_close_icon = false,
                separator_style = "thin",
                close_command = _G.smart_close,
                right_mouse_command = _G.smart_close,
                offsets = {
                  { filetype = "neo-tree", text = "File Explorer", padding = 1 },
                  { filetype = "toggleterm", text = "Terminal", padding = 1 },
                },
              },
            })

            vim.schedule(function()
              local opts = require("bufferline.config").options
              opts.close_command = _G.smart_close
              opts.right_mouse_command = _G.smart_close
            end)
          '';
        }
      ];

      programs.neovim.initLua = ''
        vim.keymap.set("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
        vim.keymap.set("n", "<C-w>", function() _G.smart_close() end, { desc = "Close split or buffer" })
      '';
    };
}
