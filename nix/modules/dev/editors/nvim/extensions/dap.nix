{
  flake.modules.homeManager.nvim = {
    programs.nixvim = {
      plugins.dap = {
        enable = true;
        lazyLoad.settings.keys = [
          {
            __unkeyed-1 = "<F5>";
            __unkeyed-2.__raw = ''
              function()
                require('lz.n').trigger_load('nvim-dap-ui')
                require('lz.n').trigger_load('nvim-dap-virtual-text')
                require('dap').continue()
              end
            '';
            desc = "Debug: Continue";
          }
          {
            __unkeyed-1 = "<F10>";
            __unkeyed-2.__raw = ''
              function()
                require('dap').step_over()
              end
            '';
            desc = "Debug: Step over";
          }
          {
            __unkeyed-1 = "<F11>";
            __unkeyed-2.__raw = ''
              function()
                require('dap').step_into()
              end
            '';
            desc = "Debug: Step into";
          }
          {
            __unkeyed-1 = "<F12>";
            __unkeyed-2.__raw = ''
              function()
                require('dap').step_out()
              end
            '';
            desc = "Debug: Step out";
          }
          {
            __unkeyed-1 = "<leader>db";
            __unkeyed-2.__raw = ''
              function()
                require('dap').toggle_breakpoint()
              end
            '';
            desc = "Toggle breakpoint";
          }
          {
            __unkeyed-1 = "<leader>du";
            __unkeyed-2.__raw = ''
              function()
                require('lz.n').trigger_load('nvim-dap-ui')
                require('lz.n').trigger_load('nvim-dap-virtual-text')
                require('dapui').toggle()
              end
            '';
            desc = "Toggle DAP UI";
          }
        ];
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
    };
  };
}
