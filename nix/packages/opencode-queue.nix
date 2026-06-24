{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  cacert,
}:

let
  src = fetchFromGitHub {
    owner = "mirsella";
    repo = "opencode-queue";
    rev = "30d5cd62300e556a9e1fa83cac1583bedb3372ad"; # follow:branch main
    hash = "sha256-zuVzklzLlNyGmCarPhTsqH0VGLaHtKQ5Nnogi8/0HHM=";
  };

  nodeModules = stdenv.mkDerivation {
    pname = "opencode-queue-node-modules";
    version = "0.10.0";
    inherit src;

    nativeBuildInputs = [
      bun
      cacert
    ];

    dontBuild = true;

    installPhase = ''
      mkdir $out
      bun install --production
      rm -rf node_modules/.cache node_modules/.bin
      cp -r node_modules $out/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-yRHauQF/+UbKCKlKbTg1mE9EClFWEVgYXBPjblMiUDQ=";
  };
in
stdenv.mkDerivation {
  pname = "opencode-queue";
  version = "0.10.0";

  inherit src;

  nativeBuildInputs = [ bun ];

  buildPhase = ''
    runHook preBuild
    cp -r ${nodeModules}/node_modules .
    bun build ./index.ts --outdir dist --target bun
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencode-queue
    cp dist/index.js $out/lib/opencode-queue/
    runHook postInstall
  '';

  meta = {
    description = "Queue OpenCode input until the current session is idle";
    homepage = "https://github.com/mirsella/opencode-queue";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
