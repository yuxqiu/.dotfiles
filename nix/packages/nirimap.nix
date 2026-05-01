{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk4,
  gtk4-layer-shell,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "nirimap";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alexandergknoll";
    repo = "nirimap";
    rev = "v${version}";
    hash = "sha256-4HnmIc9FDXgPfbJdhjuVenc2R/wZ9ULTi6QaTskO1/s=";
  };

  cargoHash = "sha256-EI79WewUTAOFivRsR2ZjywEAYZ9Lq6YnfwPml071CqU=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  meta = {
    description = "A minimal workspace minimap overlay for the Niri Wayland compositor";
    homepage = "https://github.com/alexandergknoll/nirimap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
