{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.lualine = {
      enable = true;
      settings = {
        options = {
          theme = "catppuccin-mocha";
          globalstatus = true;
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            "diff"
            "diagnostics"
          ];
          lualine_c = [
            {
              __unkeyed-1 = "filename";
              path = 1;
            }
            {
              __unkeyed-1 = "navic";
              color_correction = "dynamic";
            }
          ];
          lualine_x = [
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
      };
    };

    programs.nixvim.plugins.navic = {
      enable = true;
      callSetup = false;
    };
  };
}
