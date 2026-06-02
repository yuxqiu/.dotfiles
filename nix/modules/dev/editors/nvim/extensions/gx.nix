{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim = {
        extraConfig = ''
          let g:netrw_nogx = 1
        '';

        plugins = with pkgs.vimPlugins; [
          {
            plugin = gx-nvim;
            type = "lua";
            config = ''
              require("gx").setup({
                handlers = {
                  plugin = true,
                  github = true,
                  brewfile = true,
                  package_json = true,
                  search = true,
                  go = true,
                },
                handler_options = {
                  search_engine = "https://www.google.com/search?q=",
                },
              })
            '';
          }
        ];
      };
    };
}
