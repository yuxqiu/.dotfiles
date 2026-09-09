{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.hardtime = {
      enable = true;
      settings = {
        disable_mouse = false;
        # Re-enable Up/Down/Left/Right.
        # hardtime merges user config over its built-in defaults via
        # `vim.tbl_deep_extend("force", ...)`, so absent keys keep the
        # default (which disables all four arrow keys). We must explicitly
        # override them with `false`.
        #
        # nixvim's `toLuaObject` strips empty lists/attrsets from attrsets
        # (`removeEmptyAttrValues = true`), so `disabled_keys = { "<Up>" = []; }`
        # vanishes entirely. Using `__raw` bypasses that, and `false` is
        # respected by the plugin: `enable()` skips `if mode then`, and
        # `handler()` treats `false` as not-disabled.
        disabled_keys.__raw = ''
          {
            ["<Up>"] = false,
            ["<Down>"] = false,
            ["<Left>"] = false,
            ["<Right>"] = false,
          }
        '';
        disabled_filetypes = [
          "qf"
          "netrw"
          "neo-tree"
          "snacks_dashboard"
          "lazy"
          "mason"
          "Trouble"
        ];
      };
    };

    # f/F are remapped to flash.nvim (jump/treesitter), not find-char,
    # so the built-in hardtime hints about f/F/t/T usage are misleading.
    # nixvim's `hints` option is a typed submodule that doesn't accept
    # `false` values, so disable the specific hint patterns after setup
    # by directly mutating the config table.
    programs.nixvim.extraConfigLua = ''
      local hardtime_config = require("hardtime.config")
      for _, pattern in ipairs({
        "[^dcy=]f.h",
        "[^dcy=]F.l",
        "[^dcy=]T.h",
        "[^dcy=]t.l",
        "d[tTfF].i",
        "[vV][tTfF].[dcy]",
        '[vV][tTfF].".[dy]',
      }) do
        hardtime_config.config.hints[pattern] = false
      end
    '';
  };
}
