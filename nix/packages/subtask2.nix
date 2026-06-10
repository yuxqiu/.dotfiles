{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  cacert,
}:

let
  src = fetchFromGitHub {
    owner = "spoons-and-mirrors";
    repo = "subtask2";
    rev = "92ad854c0d3190f407bfdcb9a012a5446dbb10a0"; # follow:branch main
    hash = "sha256-30mzbGf+DTh4K2GvV4y3Il2fEHVTtnRx2JuCoHWYrLk=";
  };

  nodeModules = stdenv.mkDerivation {
    pname = "subtask2-node-modules";
    version = "0.3.5";
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
    outputHash = "sha256-LrVzcXIXtwczFk/BqxPo3g1H+empsFZG28jD05fgu8w=";
  };
in
stdenv.mkDerivation {
  pname = "subtask2";
  version = "0.3.5";

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
    mkdir -p $out/lib/subtask2
    cp dist/index.js $out/lib/subtask2/
    runHook postInstall
  '';

  meta = {
    description = "A stronger opencode /command handler";
    homepage = "https://github.com/spoons-and-mirrors/subtask2";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
