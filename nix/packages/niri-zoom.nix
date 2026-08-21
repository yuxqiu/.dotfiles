{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "niri-zoom";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Ahmedhossamdev";
    repo = "niri-zoom";
    rev = "7b0c6056d1e29331924036bd21cfcf6105d124cb"; # follow:branch master
    hash = "sha256-Sztt+4GoEZixO0lbk+eRBIcB3koHECtF6EMarFqVqjQ=";
  };

  cargoHash = "sha256-ISKNipvoRpaZ9mx6J9XUialXwuTrpRlNb+0Y5DaNIxY=";

  doCheck = false;

  meta = {
    description = "External Ctrl+scroll magnifier/zoom tool for niri and other wlr-layer-shell/screencopy Wayland compositors";
    homepage = "https://github.com/Ahmedhossamdev/niri-zoom";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
