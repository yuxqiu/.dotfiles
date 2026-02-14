{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ tirith ];

      programs.zsh.initContent = ''eval "$(tirith init)"'';
      home.sessionVariables = {
        TIRITH_LOG = 0;
      };
    };
}
