{
  flake.modules.homeManager.nvim = {
    programs.nixvim = {
      plugins.scrollview = {
        enable = true;
        settings = {
          signs_on_startup = [
            "diagnostics"
            "search"
            "marks"
          ];
          mousemove = true;
        };
      };

      extraConfigLua = ''
        require("scrollview.contrib.gitsigns").setup()
      '';

      keymaps = [
        {
          key = "<leader>jn";
          action = "<cmd>ScrollViewNext<CR>";
          options.desc = "Next scrollview sign";
        }
        {
          key = "<leader>jp";
          action = "<cmd>ScrollViewPrev<CR>";
          options.desc = "Prev scrollview sign";
        }
      ];
    };
  };
}
