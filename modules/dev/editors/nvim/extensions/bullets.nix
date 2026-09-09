{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.bullets = {
      enable = true;
      settings = {
        enabled_file_types = [
          "markdown"
          "text"
          "gitcommit"
          "scratch"
        ];
        set_mappings = 1;
        default_bullet = "-";
        nested_mappings = 1;
        enable_in_empty_buffers = 0;
        custom_mappings = [
          [
            "imap"
            "<C-Tab>"
            "<Plug>(bullets-demote)"
          ]
          [
            "imap"
            "<C-S-Tab>"
            "<Plug>(bullets-promote)"
          ]
        ];
      };
    };
  };
}
