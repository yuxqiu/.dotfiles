{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ inputs.tirith.packages.${pkgs.stdenv.system}.default ];

      programs.zsh.initContent = ''eval "$(tirith init)"'';
      home.sessionVariables = {
        TIRITH_LOG = 0;
      };
    };
}
