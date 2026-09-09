{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.neotab = {
      enable = true;
      settings = {
        tabkey = "<Tab>";
        reverse_key = "<S-Tab>";
        act_as_tab = true;
        behavior = "nested";
        pairs = [
          {
            open = "(";
            close = ")";
          }
          {
            open = "[";
            close = "]";
          }
          {
            open = "{";
            close = "}";
          }
          {
            open = "'";
            close = "'";
          }
          {
            open = "\"";
            close = "\"";
          }
          {
            open = "`";
            close = "`";
          }
        ];
      };
    };
  };
}
