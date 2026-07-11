{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "browse";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "browserbase";
    repo = "stagehand";
    rev = "browse@${finalAttrs.version}";
    hash = "sha256-VJkaCbphF1VA2cvG3wX07Bju6lcmytR8xfrohuUSLEw=";
  };

  pnpmDeps = fetchPnpmDeps {
    pname = finalAttrs.pname;
    inherit (finalAttrs) version src;
    pnpm = pnpm_10;
    pnpmWorkspaces = [ "browse..." ];
    fetcherVersion = 3;
    hash = "sha256-w9XM76XoP+IFgfh7Q4Nzq68f8OhUaOzYYBNLgXwLieU=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  pnpmWorkspaces = [ "browse..." ];

  env = {
    CI = "true";
    TURBO_CACHE_DIR = "/tmp/turbo-cache";
  };

  buildPhase = ''
    runHook preBuild
    pnpm exec turbo run build --filter=browse --force --no-daemon
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/browse/packages
    # Preserve pnpm symlink structure: root node_modules (.pnpm store) + workspace packages
    cp -r node_modules $out/lib/browse/node_modules
    cp -r packages/cli $out/lib/browse/packages/cli
    cp -r packages/core $out/lib/browse/packages/core
    mkdir -p $out/bin
    makeWrapper $out/lib/browse/packages/cli/bin/run.js $out/bin/browse
    runHook postInstall
  '';

  meta = {
    description = "Unified Browserbase CLI for browser automation and cloud APIs";
    homepage = "https://github.com/browserbase/stagehand/tree/main/packages/cli";
    license = lib.licenses.mit;
    mainProgram = "browse";
    platforms = lib.platforms.all;
  };

  passthru = { inherit (finalAttrs) src; };
})
