{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.markview = {
      enable = true;
      lazyLoad.settings.ft = [
        "markdown"
        "typst"
        "latex"
      ];
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

    programs.nixvim.keymaps = [
      {
        key = "<leader>um";
        action.__raw = ''
          function()
            require('lz.n').trigger_load('markview.nvim')
            require("markview.commands").toggle()
          end
        '';
        options.desc = "Toggle markview";
      }
    ];
  };
}
