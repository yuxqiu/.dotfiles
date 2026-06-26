{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  nodejs,
  fetchNpmDeps,
  npmHooks,
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
  libayatana-appindicator,
  wrapGAppsHook4,
  # runtime tools the app shells out to for activity tracking
  xdotool,
  xprintidle,
  tesseract5,
  grim,
  procps,
  xorg,
}:

let
  runtimePath = lib.makeBinPath [
    xdotool
    xprintidle
    tesseract5
    grim
    procps
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "work-review";
  version = "1.0.52";

  src = fetchFromGitHub {
    owner = "wm94i";
    repo = "Work-Review";
    rev = "v${version}";
    hash = "sha256-QSZF7KGaYFRtsnH97eCoIpdKBKd6nZKCEdBFY0m7aVI=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  # Cargo.lock is at the workspace root, not in src-tauri/, so fetch the
  # vendor dir from the full source tree rather than letting buildRustPackage
  # pass cargoRoot to fetchCargoVendor.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-Uobw1hOvEBhjbJQI/ofocoteISdL+zya5BmZuHYeM14=";
  };

  npmDeps = fetchNpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    hash = "sha256-GlndpWR6KJqEK7SupIylV8wT67DzTsbVskCQElM+NE0=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
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
    libayatana-appindicator
    xorg.libX11
    xorg.libXi
  ];

  doCheck = false;

  postPatch = ''
    # Cargo.lock is at the workspace root, but cargoRoot points to src-tauri/.
    cp Cargo.lock src-tauri/Cargo.lock

    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
    sed -i 's/"pubkey": "[^"]*"/"pubkey": ""/' src-tauri/tauri.conf.json
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${runtimePath}
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]}
    )
  '';

  env = {
    CI = "true";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  };

  meta = {
    description = "Local-first work review tool that tracks apps, websites, and time";
    homepage = "https://github.com/wm94i/Work-Review";
    license = lib.licenses.mit;
    mainProgram = "Work_Review";
    platforms = [ "x86_64-linux" ];
  };
}
