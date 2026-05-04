{ inputs, ... }:
{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    let
      smart-paste-nvim = pkgs.callPackage (inputs.self + /packages/smart-paste-nvim.nix) { };
    in
    {
      programs.neovim.plugins = [
        {
          plugin = smart-paste-nvim;
          type = "lua";
          config = ''
            require("smart-paste").setup()
          '';
        }
      ];
    };
}
