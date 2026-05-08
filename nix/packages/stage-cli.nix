{
  lib,
  stdenv,
  nodejs,
  pnpm,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  python3,
  makeWrapper,
  node-gyp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stagereview";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ReviewStage";
    repo = "stage-cli";
    rev = "0ed89555e1d3be9c95731208493551de7f622d4b"; # follow:branch main
    hash = "sha256-xE/2gPo0i1eoDxCTYbWc3B737BcIc/YwiQUwWI0ftL0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-i8N5eqhNgKMJRN5ASbLoSGxLx7HAjci8FJm8R18zvG0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
    python3
    node-gyp
    makeWrapper
  ];

  pnpmWorkDir = "packages/cli";

  buildPhase = ''
    runHook preBuild

    pushd node_modules/.pnpm/better-sqlite3@*/node_modules/better-sqlite3
    node-gyp rebuild --release
    popd

    pnpm --filter @stagereview/web build
    pnpm --filter stagereview build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/stagereview
    cp -r . $out/lib/stagereview/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/stagereview \
      --add-flags $out/lib/stagereview/packages/cli/dist/index.js

    runHook postInstall
  '';

  meta = {
    description = "AI-powered code review tool that organizes local code changes into logical chapters";
    homepage = "https://github.com/ReviewStage/stage-cli";
    license = lib.licenses.mit;
    mainProgram = "stagereview";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
