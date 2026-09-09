{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  cacert,
}:

let
  src = fetchFromGitHub {
    owner = "aptdnfapt";
    repo = "btw-opencode";
    rev = "9ad0be28d29c353425a19c51ff9a4352b231c4a8"; # follow:branch main
    hash = "sha256-91gdc8WDl1aI5NO4TV+i3ocrWt8gRwPjMjp6WA2wOEQ=";
  };

  nodeModules = stdenv.mkDerivation {
    pname = "btw-opencode-node-modules";
    version = "0.0.1";
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
    outputHash = "sha256-lJe+8ELnWTb6e0WJOCrNqBxbELHQW8duC4rSDDe81O0=";
  };
in
stdenv.mkDerivation {
  pname = "btw-opencode";
  version = "0.0.1";

  inherit src;

  nativeBuildInputs = [ bun ];

  buildPhase = ''
    runHook preBuild
    cp -r ${nodeModules}/node_modules .
    bun build ./src/index.ts --outfile dist/btw-opencode.js --target node
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/btw-opencode
    cp dist/btw-opencode.js $out/lib/btw-opencode/
    runHook postInstall
  '';

  meta = {
    description = "Fork session and run prompts in background for OpenCode";
    homepage = "https://github.com/aptdnfapt/btw-opencode";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
