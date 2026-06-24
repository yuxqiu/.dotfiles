{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.dap = {
          enable = true;
          lazyLoad.settings.keys = [
            "<F5>"
            "<F10>"
            "<F11>"
            "<F12>"
            "<leader>db"
          ];
        };

        plugins.dap-ui = {
          enable = true;
          lazyLoad.settings = {
            before.__raw = ''
              function()
                require('lz.n').trigger_load('nvim-dap')
              end
            '';
            keys = [ "<leader>du" ];
          };
          luaConfig.post = ''
            local dap = require("dap")
            local dapui = require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close
          '';
        };

        plugins.dap-virtual-text = {
          enable = true;
          lazyLoad.settings.keys = [
            "<F5>"
            "<leader>db"
            "<leader>du"
          ];
        };

        keymaps = [
          {
            key = "<F5>";
            action.__raw = "require('dap').continue";
            options.desc = "Debug: Continue";
          }
          {
            key = "<F10>";
            action.__raw = "require('dap').step_over";
            options.desc = "Debug: Step over";
          }
          {
            key = "<F11>";
            action.__raw = "require('dap').step_into";
            options.desc = "Debug: Step into";
          }
          {
            key = "<F12>";
            action.__raw = "require('dap').step_out";
            options.desc = "Debug: Step out";
          }
          {
            key = "<leader>db";
            action.__raw = "require('dap').toggle_breakpoint";
            options.desc = "Toggle breakpoint";
          }
          {
            key = "<leader>du";
            action.__raw = "require('dapui').toggle";
            options.desc = "Toggle DAP UI";
          }
        ];
      };
    };
}
