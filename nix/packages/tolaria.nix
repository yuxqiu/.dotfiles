{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  nodejs_22,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  gtk3,
  cairo,
  gdk-pixbuf,
  glib,
  dbus,
  librsvg,
  pango,
  atk,
  libsoup_3,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "tolaria";
  version = "2026.4.28";

  src = fetchFromGitHub {
    owner = "refactoringhq";
    repo = "tolaria";
    rev = "stable-v${version}";
    hash = "sha256-70TZpwhIutDqNg753z+YNeN2AcHS50i1k7y/XVWbOOs=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoHash = "sha256-RgmnugsSt7sYD2nNsEPBl0TOjHquQWdxz/Nt3iqvhQE=";

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    hash = "sha256-4adqavN/H+eaI71iyKdcuooNHp3Oy03S7ecApACK984=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs_22
    pnpm
    pnpmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    librsvg
    pango
    atk
    libsoup_3
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"pubkey": "dW50cnVzdGVkIGNvbW1lbnQ6IG1pbmlzaWduIHB1YmxpYyBrZXk6IEE4NkQ5MDI3REVCRkFGNUMKUldSY3I3L2VKNUJ0cU5JRlRZZlp3NGhnU3ZwbkVKeGVvREpmb2sxRVJndHFpVFZPNlArbEE5R1IK"' '"pubkey": ""'
  '';

  env = {
    CI = "true";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  };
}
