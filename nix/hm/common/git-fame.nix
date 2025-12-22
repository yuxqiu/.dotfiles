{ pkgs, ... }:
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "git-fame"; # Customize this name
      paths = [ pkgs.git-fame ]; # The original package
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/git-fame \
          --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}
      '';
    })
  ];
}
