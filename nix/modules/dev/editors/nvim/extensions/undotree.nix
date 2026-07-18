{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.undotree = {
      enable = true;
      settings = {
        WindowLayout = 4;
        ShortIndel = 1;
      };
    };

    programs.nixvim.keymaps = [
      {
        mode = "n";
        key = "<leader>ut";
        action = "<cmd>UndotreeToggle<CR>";
        options.desc = "Toggle undotree";
      }
    ];
  };
}
