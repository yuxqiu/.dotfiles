{
  flake.modules.homeManager.gh =
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
