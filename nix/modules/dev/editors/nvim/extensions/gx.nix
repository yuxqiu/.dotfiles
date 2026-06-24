{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.gx = {
        enable = true;
        settings = {
          handlers = {
            plugin = true;
            github = true;
            brewfile = true;
            package_json = true;
            search = true;
            go = true;
          };
          handler_options = {
            search_engine = "https://www.google.com/search?q=";
          };
        };
      };
    };
}
