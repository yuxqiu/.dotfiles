{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-dap;
          optional = true;
        }

        {
          plugin = nvim-dap-ui;
          optional = true;
        }

        {
          plugin = nvim-dap-virtual-text;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        local dap_loaded = false
        local function load_dap()
          if dap_loaded then return end
          dap_loaded = true
          lazy_load("nvim-dap", nil, nil)
          lazy_load("nvim-dap-ui", nil, nil)
          lazy_load("nvim-dap-virtual-text", nil, nil)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup()
          require("nvim-dap-virtual-text").setup()
          dap.listeners.after.event_initialized["dapui_config"] = dapui.open
          dap.listeners.before.event_terminated["dapui_config"] = dapui.close
          dap.listeners.before.event_exited["dapui_config"] = dapui.close
          vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
          vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
          vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
          vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
          vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
          vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
        end

        vim.keymap.set("n", "<F5>", function() load_dap(); require("dap").continue() end, { desc = "Debug: Continue" })
        vim.keymap.set("n", "<leader>db", function() load_dap(); require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>du", function() load_dap(); require("dapui").toggle() end, { desc = "Toggle DAP UI" })
      '';
    };
}
