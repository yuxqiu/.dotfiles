{
  flake.modules.homeManager.nvim = {
    programs.nixvim.extraConfigLua = ''
      _G._debounce_timers = {}

      _G.debounce = function(key, ms, fn)
        if _G._debounce_timers[key] then
          _G._debounce_timers[key]:stop()
          _G._debounce_timers[key]:close()
        end
        _G._debounce_timers[key] = vim.uv.new_timer()
        _G._debounce_timers[key]:start(ms, 0, function()
          _G._debounce_timers[key]:close()
          _G._debounce_timers[key] = nil
          vim.schedule(fn)
        end)
      end

      _G.open_result_split = function(title, lines)
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
        vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
        vim.api.nvim_set_option_value("filetype", "log", { buf = buf })
        vim.cmd("belowright split")
        vim.api.nvim_win_set_buf(0, buf)
        vim.api.nvim_buf_set_name(buf, title or "Code Lens Result")
      end
    '';
  };
}
