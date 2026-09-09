{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.cutlass-nvim = {
      enable = true;
      settings = {
        cut_key = "X";
        exclude = [
          "ns"
          "nS"
        ];
      };
    };
  };
}
