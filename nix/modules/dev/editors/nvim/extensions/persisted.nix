{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.persisted = {
      enable = true;
      settings = {
        autostart = true;
        autoload = true;
        should_save.__raw = ''
          function()
            local bufs = vim.tbl_filter(function(b)
              if vim.bo[b].buftype ~= "" or vim.tbl_contains({ "gitcommit", "gitrebase", "jj" }, vim.bo[b].filetype) then
                return false
              end
              return vim.api.nvim_buf_get_name(b) ~= ""
            end, vim.api.nvim_list_bufs())
            if #bufs < 1 then
              return false
            end
            return true
          end
        '';
      };
    };

    programs.nixvim.autoGroups.PersistedSavePre = {
      clear = true;
    };

    programs.nixvim.autoCmd = [
      {
        event = [ "User" ];
        pattern = [ "PersistedSavePre" ];
        group = "PersistedSavePre";
        callback.__raw = ''
          function()
            -- Ensure the neo-tree plugin is not written into the session
            pcall(vim.cmd, "bw neo-tree")
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.bo[buf].filetype == "neo-tree" then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end
        '';
      }
    ];

    programs.nixvim.extraConfigLua = ''
      vim.keymap.set("n", "<leader>qs", function() require("persisted").load() end, { desc = "Restore session" })
      vim.keymap.set("n", "<leader>qS", function() require("persisted").select() end, { desc = "Select session" })
      vim.keymap.set("n", "<leader>ql", function() require("persisted").load_last() end, { desc = "Restore last session" })
      vim.keymap.set("n", "<leader>qd", function() require("persisted").stop() end, { desc = "Stop session saving" })
    '';
  };
}
