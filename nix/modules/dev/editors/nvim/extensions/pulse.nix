{ inputs, ... }:
{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    let
      pulse-nvim = pkgs.callPackage (inputs.self + /packages/pulse-nvim.nix) { };
    in
    {
      programs.neovim.plugins = [
        {
          plugin = pulse-nvim;
          type = "lua";
          config = ''
            require("pulse").setup({
              position = "top",
              width = 0.70,
              height = 0.90,
              border = "rounded",
              workspace_label = false,
            })

            local pulse_mod = require("pulse.pulse")
            local switch_prompt = require("pulse.config").switch_prompt

            local function is_pulse_buf(buf)
              return vim.fn.exists("#PulseUIInput" .. buf) == 1
            end

            vim.keymap.set("n", "<C-p>", function()
              pulse_mod.open({})
              vim.schedule(function()
                if pulse_mod.get_prompt() and pulse_mod.get_prompt() ~= "" then
                  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if is_pulse_buf(buf) then
                      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
                    end
                  end
                end
              end)
            end, { desc = "Command palette" })
            vim.keymap.set("n", "<C-S-F>", function()
              pulse_mod.open({ initial_prompt = switch_prompt("", "live_grep") })
            end, { desc = "Search in project" })

            -- Fix: stopinsert shifts cursor left by 1. Compensate with normal! l.
            vim.api.nvim_create_autocmd("BufWinLeave", {
              group = vim.api.nvim_create_augroup("PulseCursorFix", { clear = true }),
              callback = function(args)
                if is_pulse_buf(args.buf) then
                  vim.schedule(function()
                    vim.cmd("normal! l")
                  end)
                end
              end,
            })

            -- Fix: editing keys in Pulse's prompt buffer.
            -- Neovim's C code redirects <C-W> in prompt buffers to window commands.
            -- <S-C-W> (Shift+Ctrl+W) does word delete natively. Map <C-W>/<C-BS>
            -- to <S-C-W> so Ctrl+W and Ctrl+Backspace delete words as expected.
            -- BufWinEnter fires before buftype is set, so use WinEnter.
            vim.api.nvim_create_autocmd("WinEnter", {
              group = vim.api.nvim_create_augroup("PulseEditing", { clear = true }),
              callback = function()
                local buf = vim.api.nvim_get_current_buf()
                if is_pulse_buf(buf) then
                  local opts = { buffer = buf, remap = true, silent = true }
                  vim.keymap.set("i", "<C-W>", "<S-C-W>", opts)
                  vim.keymap.set("i", "<C-BS>", "<S-C-W>", opts)
                end
              end,
            })
          '';
        }
      ];
    };
}
