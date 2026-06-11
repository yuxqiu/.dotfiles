{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  cacert,
}:

let
  src = fetchFromGitHub {
    owner = "joshuadavidthomas";
    repo = "opencode-handoff";
    rev = "v0.5.0";
    hash = "sha256-SNLSNrM6QWeR6DL6cVqb6xWyTqvg0cqyyLxc37M7wBY=";
  };

  nodeModules = stdenv.mkDerivation {
    pname = "opencode-handoff-node-modules";
    version = "0.5.0";
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
    outputHash = "sha256-DQOfb6+N7dYf2bvw8JnXVQDI3ey+M7l6OxVXVyKqeNU=";
  };
in
stdenv.mkDerivation rec {
  pname = "opencode-handoff";
  version = "0.5.0";

  inherit src;

  nativeBuildInputs = [ bun ];

  buildPhase = ''
    runHook preBuild
    cp -r ${nodeModules}/node_modules .
    bun build ./src/plugin.ts --outdir dist --target bun
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencode-handoff
    cp dist/plugin.js $out/lib/opencode-handoff/
    runHook postInstall
  '';

  meta = {
    description = "Create focused handoff prompts for continuing work in new OpenCode sessions";
    homepage = "https://github.com/joshuadavidthomas/opencode-handoff";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
