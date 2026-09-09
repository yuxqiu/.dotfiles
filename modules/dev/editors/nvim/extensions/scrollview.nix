{
  flake.modules.homeManager.nvim = {
    programs.nixvim = {
      plugins.scrollview = {
        enable = true;
        settings = {
          signs_on_startup = [
            "diagnostics"
            "marks"
          ];
          mousemove = true;
        };
      };

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
