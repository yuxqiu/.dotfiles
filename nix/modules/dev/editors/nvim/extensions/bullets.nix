{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = bullets-vim;
          type = "lua";
          config = ''
            vim.g.bullets_enabled_file_types = {
              "markdown",
              "text",
              "gitcommit",
              "scratch",
            }
            vim.g.bullets_set_mappings = 1
            vim.g.bullets_default_bullet = "-"
            vim.g.bullets_nested_mappings = 1
            vim.g.bullets_enable_in_empty_buffers = 0
            vim.g.bullets_custom_mappings = {
              { "imap", "<C-Tab>", "<Plug>(bullets-demote)" },
              { "imap", "<C-S-Tab>", "<Plug>(bullets-promote)" },
            }
          '';
        }
      ];
    };
}
