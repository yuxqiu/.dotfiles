{
  flake.modules.homeManager.nvim =
    { config, lib, ... }:
    lib.mkIf (config.my.dev.languages ? markdown) {
      programs.neovim.initLua = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "markdown",
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
          end,
        })
      '';
    };
}
