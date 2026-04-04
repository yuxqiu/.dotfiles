{
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.gh = {
        enable = true;

        settings = {
          git_protocol = "ssh";
        };
      };
    };
}
