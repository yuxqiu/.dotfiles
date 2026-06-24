{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.markview = {
      enable = true;
      lazyLoad.settings = {
        ft = [
          "markdown"
          "typst"
          "latex"
        ];
        keys = [
          {
            __unkeyed-1 = "<leader>um";
            __unkeyed-2.__raw = ''
              function()
                require("markview.commands").toggle()
              end
            '';
            desc = "Toggle markview";
          }
        ];
      };
      settings = {
        preview = {
          enable = true;
          filetypes = [
            "markdown"
            "typst"
            "latex"
          ];
          hybrid_modes = [ "n" ];
        };
      };
    };
  };
}
