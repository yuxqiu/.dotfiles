{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        ts_config = {
          lua = [
            "string"
            "source"
          ];
          javascript = [
            "string"
            "template_string"
          ];
        };
        disable_filetype = [
          "TelescopePrompt"
          "spectre_panel"
          "grug-far"
        ];
        fast_wrap = {
          map = "<M-e>";
          chars = [
            "{"
            "["
            "("
            "\""
            "'"
          ];
          pattern.__raw = ''string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s", "")'';
          end_key = "$";
          keys = "qwertyuiopzxcvbnmasdfghjkl";
          check_comma = true;
          highlight = "Search";
          highlight_grey = "Comment";
        };
      };
    };

    programs.nixvim.extraConfigLua = ''
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    '';
  };
}
