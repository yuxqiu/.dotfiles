{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = which-key-nvim;
          type = "lua";
          config = ''
            require("which-key").setup({
              replace = {
                ["<leader>"] = "SPC",
                ["<cr>"] = "RET",
                ["<tab>"] = "TAB",
              },
              spec = {
                { "<leader>R", group = "remote", icon = "󰢟" },
                { "<leader>c", group = "code", icon = "󰚌" },
                { "<leader>d", group = "debug", icon = "󰃤" },
                { "<leader>f", group = "find", icon = "󰈞" },
                { "<leader>g", group = "git", icon = "󰊢" },
                { "<leader>j", group = "jump", icon = "󰆔" },
                { "<leader>l", group = "line", icon = "󰅂" },
                { "<leader>q", group = "session", icon = "󰅴" },
                { "<leader>s", group = "search", icon = "󰍉" },
                { "<leader>t", group = "trouble", icon = "󰀨" },
                { "<leader>u", group = "toggle", icon = "󰔲" },
              },
            })
          '';
        }
      ];
    };
}
