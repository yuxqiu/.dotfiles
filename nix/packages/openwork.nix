{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  autoPatchelfHook,
  # runtime libraries the bundled Electron binary links against
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libxcb,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  xorg,
}:

let
  # autoPatchelfHook's env hook adds `$dep/lib` of every buildInput to the
  # `--libs` search path; resolve the lib output so split outputs like
  # dbus.lib / cups.lib are picked up correctly.
  runtimeLibs = map lib.getLib [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libxcb
    libxkbcommon
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXtst
    stdenv.cc.cc.lib # libstdc++ / libgcc_s for the bundled native node modules
  ];

  desktopItem = makeDesktopItem {
    name = "openwork";
    desktopName = "OpenWork";
    comment = "Run agents, skills, and MCP workflows";
    exec = "openwork %U";
    icon = "openwork";
    terminal = false;
    categories = [
      "Development"
      "Utility"
    ];
    startupWMClass = "OpenWork";
    mimeTypes = [ "x-scheme-handler/openwork" ];
  };
in
stdenv.mkDerivation rec {
  pname = "openwork";
  version = "0.17.2";

  src = fetchurl {
    url = "https://github.com/different-ai/openwork/releases/download/v${version}/openwork-linux-x64-${version}.tar.gz";
    hash = "sha256-NLRVXdU9PLx+0hBPeg7Jr+oIPyBkWZcmxWyHGIG5oA4=";
  };

  sourceRoot = "openwork-linux-x64-${version}";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # autoPatchelfHook's env hook adds `$dep/lib` of every buildInput to the
  # `--libs` search path (we resolve the lib output so split outputs like
  # dbus.lib / cups.lib are picked up correctly).
  buildInputs = runtimeLibs;

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/openwork
    cp -a * $out/lib/openwork/

    # chrome-sandbox can't be setuid in the nix store; run without the setuid
    # sandbox instead (see --no-sandbox on the wrapper below).
    rm -f $out/lib/openwork/chrome-sandbox

    mkdir -p $out/bin
    # libGL.so.1 is dlopen'd by ANGLE at runtime (not a NEEDED entry), so it
    # must be on LD_LIBRARY_PATH rather than in autoPatchelf's RPATH.
    makeWrapper $out/lib/openwork/@openworkdesktop $out/bin/openwork \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]} \
      --add-flags "--no-sandbox" \
      --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime}}"

    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm644 \
      $out/lib/openwork/resources/app-dist/openwork-logo-square.svg \
      $out/share/icons/hicolor/scalable/apps/openwork.svg

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    runHook postInstall
  '';

  meta = {
    description = "Open-source alternative to Claude Cowork (powered by opencode)";
    homepage = "https://github.com/different-ai/openwork";
    license = lib.licenses.mit;
    mainProgram = "openwork";
    platforms = [ "x86_64-linux" ];
  };
}
