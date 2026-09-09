{ inputs, ... }:
{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    let
      smart-paste-nvim = pkgs.callPackage (inputs.self + /packages/smart-paste-nvim.nix) { };
    in
    {
      programs.nixvim.extraPlugins = [
        smart-paste-nvim
      ];

      programs.nixvim.extraConfigLua = ''
        require("smart-paste").setup()
      '';
    };
}
