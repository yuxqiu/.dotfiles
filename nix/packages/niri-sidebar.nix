{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "niri-sidebar";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Vigintillionn";
    repo = "niri-sidebar";
    rev = "v${version}";
    hash = "sha256-MYP1ZiwV9+yJhl0zpuri6NQkQHlaYZjGBhXpZEaPZyI=";
  };

  cargoHash = "sha256-zZlfwAxWE1ZZy6k7QoBOamCGigGShd89sD27vfvgR00=";

  doCheck = false;

  meta = {
    description = "A lightweight, external sidebar manager for the Niri window manager";
    homepage = "https://github.com/Vigintillionn/niri-sidebar";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}