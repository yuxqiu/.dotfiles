{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = persistence-nvim;
          type = "lua";
          config = ''
            require("persistence").setup({
              dir = vim.fn.stdpath("state") .. "/sessions/",
              need = 1,
              branch = true,
            })

            vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
            vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select session" })
            vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
            vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Stop session saving" })
          '';
        }
      ];
    };
}