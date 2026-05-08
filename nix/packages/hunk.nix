{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  writableTmpDirAsHomeHook,
}:

let
  deps = stdenv.mkDerivation rec {
    pname = "hunk-deps";
    version = "0.10.0";

    src = fetchFromGitHub {
      owner = "modem-dev";
      repo = "hunk";
      rev = "v${version}";
      hash = "sha256-S2EuZW5vzyk3FGhUQbyanE3hdlnb9F6GQMtu2k8pjrM=";
    };

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      bun install --frozen-lockfile --ignore-scripts --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/source
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-VT96Z7j5mLh/Z7CqddJ6HVgEV5J+tamt/1ozasxJ1Y0=";
  };
in

stdenv.mkDerivation {
  pname = "hunk";
  inherit (deps) version;

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  unpackPhase = ''
    cp -r ${deps}/source source
    chmod -R +w source
    cd source
  '';

  buildPhase = ''
    runHook preBuild
    BUN_TMPDIR=$(mktemp -d) \
    BUN_INSTALL=$NIX_BUILD_TOP/.bun-install \
    bun build --compile src/main.tsx --outfile hunk
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 hunk $out/bin/hunk
    cp -r skills $out/bin/skills
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Review-first terminal diff viewer for agentic coders";
    homepage = "https://github.com/modem-dev/hunk";
    license = lib.licenses.mit;
    mainProgram = "hunk";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
