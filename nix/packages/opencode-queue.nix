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
    rev = "9ca961a31a8dcfc5051755fe7a44d34aaeb77705"; # follow:branch main
    hash = "sha256-hjO8rH//es9zB5yJpF6UdOrquzlCIgJmE09KfLWv/KI=";
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
