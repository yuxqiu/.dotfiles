{ pkgs, ... }:

let
  # Wrap VSCode with custom flags
  vscodeWithFlags = pkgs.symlinkJoin {
    name = "vscode-with-flags";
    paths = [ pkgs.vscode ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/code \
        --add-flags "--enable-zero-copy" \
        --add-flags "--enable-direct-composition" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--ozone-platform-hint=auto" \
        --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations" \
        --add-flags "--enable-features=Vulkan"
    '';
    meta = pkgs.vscode.meta // { mainProgram = "code"; };
    passthru = pkgs.vscode.passthru;
  };
  vscodeWithFlagsFixed = vscodeWithFlags.overrideAttrs (old: {
    pname = "vscode";
    version = pkgs.vscode.version;
  });
in { programs.vscode.package = vscodeWithFlagsFixed; }
