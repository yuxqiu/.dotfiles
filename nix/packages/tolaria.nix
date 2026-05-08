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
  version = "2026-05-07";

  src = fetchFromGitHub {
    owner = "refactoringhq";
    repo = "tolaria";
    rev = "v${version}";
    hash = "sha256-oPw9Xzgxgf73DxEQK0ri1lLZhVleg9tRavutqmyzI/E=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoHash = "sha256-n2Nzkmtc/bTebMOnoi+27T91m5b2051E4gQiSpEjSdM=";

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    hash = "sha256-bNXWwL/I6lKbWfE/p0FW6Iey5n1Kq6PmuYQqcdMMaiA=";
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
