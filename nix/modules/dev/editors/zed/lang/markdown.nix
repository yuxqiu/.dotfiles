{
  flake.modules.homeManager.zed =
    { config, lib, ... }:
    {
      programs.zed-editor = {
        userSettings.languages = lib.mkIf (config.my.dev.languages ? markdown) {
          Markdown = {
            format_on_save = "on";
          };
        };
        extensions = lib.mkIf (config.my.dev.languages ? markdown) [ "markdown-oxide" ];
      };
    };
}
