{
  flake.modules.homeManager.nvim = {
    programs.nixvim = {
      plugins.dap = {
        enable = true;
        lazyLoad.settings.lazy = true;
      };

      plugins.dap-ui = {
        enable = true;
        lazyLoad.settings.lazy = true;
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
        lazyLoad.settings.lazy = true;
      };

      keymaps = [
        {
          key = "<F5>";
          action.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
              require('lz.n').trigger_load('nvim-dap-ui')
              require('lz.n').trigger_load('nvim-dap-virtual-text')
              require('dap').continue()
            end
          '';
          options.desc = "Debug: Continue";
        }
        {
          key = "<F10>";
          action.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
              require('dap').step_over()
            end
          '';
          options.desc = "Debug: Step over";
        }
        {
          key = "<F11>";
          action.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
              require('dap').step_into()
            end
          '';
          options.desc = "Debug: Step into";
        }
        {
          key = "<F12>";
          action.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
              require('dap').step_out()
            end
          '';
          options.desc = "Debug: Step out";
        }
        {
          key = "<leader>db";
          action.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
              require('dap').toggle_breakpoint()
            end
          '';
          options.desc = "Toggle breakpoint";
        }
        {
          key = "<leader>du";
          action.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
              require('lz.n').trigger_load('nvim-dap-ui')
              require('lz.n').trigger_load('nvim-dap-virtual-text')
              require('dapui').toggle()
            end
          '';
          options.desc = "Toggle DAP UI";
        }
      ];
    };
  };
}
