{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
          nvim-hlslens
        ];

        extraConfigLua = ''
          require("hlslens").setup({})
        '';
      };
    };
}
