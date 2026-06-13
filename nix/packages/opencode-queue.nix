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
    rev = "eed2696c52f62088fb3a7ea33d30ea1d75a0a6b3"; # follow:branch main
    hash = "sha256-fHj6eNygikYSMkKiXDhHzpBfV1Cccx1QyE6fgBoW/K8=";
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
      rm -rf node_modules/.cache
      cp -r node_modules $out/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-C4Uu4HCtG9JBsLgLHxdUgJJ1Ga2ubmpcXQy2l679X3g=";
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
