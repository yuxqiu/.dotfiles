{
  flake.modules.homeManager.zed =
    { config, lib, ... }:
    {
      programs.zed-editor = {
        userSettings = {
          languages = lib.mkIf (config.my.dev.languages ? typst) {
            Typst = {
              soft_wrap = "editor_width";
            };
          };
          lsp = lib.mkIf (config.my.dev.languages ? typst) {
            tinymist = {
              settings = {
                exportPdf = "onSave";
              };
            };
          };
        };
        extensions = lib.mkIf (config.my.dev.languages ? typst) [ "typst" ];
      };
    };
}
