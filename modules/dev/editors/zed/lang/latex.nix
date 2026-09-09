{
  flake.modules.homeManager.zed =
    { config, lib, ... }:
    {
      programs.zed-editor = {
        userSettings = {
          languages = lib.mkIf (config.my.dev.languages ? latex) {
            BibTeX = {
              formatter = {
                external = {
                  command = "latexindent";
                  arguments = [
                    "-l"
                    "-g"
                    "/dev/null"
                  ];
                };
              };
            };
            LaTeX = {
              soft_wrap = "editor_width";
            };
          };
          lsp = lib.mkIf (config.my.dev.languages ? latex) {
            texlab = {
              settings = {
                texlab = {
                  build = {
                    onSave = true;
                    forwardSearchAfter = true;
                    executable = "tectonic";
                    args = [
                      "-X"
                      "compile"
                      "%f"
                      "--untrusted"
                      "--synctex"
                      "--keep-logs"
                      "--keep-intermediates"
                    ];
                  };
                };
              };
            };
          };
        };
        extensions = lib.mkIf (config.my.dev.languages ? latex) [ "latex" ];
      };
    };
}
