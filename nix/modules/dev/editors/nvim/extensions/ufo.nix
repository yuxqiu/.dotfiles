{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
        promise-async
      ];

      programs.nixvim.plugins.nvim-ufo = {
        enable = true;
        settings = {
          provider_selector.__raw = ''
            function(_, _, _)
              return { "treesitter", "indent" }
            end
          '';
        };
      };

      programs.nixvim.extraConfigLua = ''
        vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
        vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
        vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" })
        vim.keymap.set("n", "zp", function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end, { desc = "Peek fold" })
      '';
    };
}
