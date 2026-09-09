# CodeBurn - See where your AI coding tokens go
# Built from GitHub source using buildNpmPackage + tsup.
# Recipe adapted from https://github.com/selfhost-it/codeburn-nix
#
# To update:
#   1. Change `version`
#   2. Update `hash` (set to "" and build — nix will tell you the correct hash)
#   3. Update `npmDepsHash` (set to "" and build — nix will tell you the correct hash)
#   4. Update `dashDeps.hash` the same way (dashboard lockfile in dash/)
#   5. Refresh the litellm price snapshot pinned in `litellmRaw` (see comment below)
#   6. Run `nix build`
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  nodejs_22,
}:

let
  version = "0.9.20";

  src = fetchFromGitHub {
    owner = "getagentseal";
    repo = "codeburn";
    rev = "v${version}";
    hash = "sha256-t9T6cMIveGsX60HSHKoqXbk7Hrd0CkRxryZUnmgQI5c=";
  };

  # Since v0.9.16 the React web dashboard lives in `dash/` as a separate npm
  # package with its own lockfile, and the root `build` script runs
  # `cd dash && npm install && npm run build`. That nested install cannot reach
  # the network in the sandbox, so its dependencies are vendored here as a
  # second fixed-output derivation and provisioned in `preBuild` instead.
  dashDeps = fetchNpmDeps {
    name = "codeburn-${version}-dash-npm-deps";
    src = "${src}/dash";
    hash = "sha256-f/vuxG8XSUl1tcYSJGwgdznzVAMk+i/ftdzWr37PF+Y=";
  };

  # Since v0.9.4, `npm run build` invokes `node scripts/bundle-litellm.mjs`,
  # which fetches a JSON snapshot from BerriAI/litellm at build time. Network
  # access is forbidden inside the Nix sandbox, so we vendor the file via a
  # fixed-output `fetchurl` and patch the script to read from the local store
  # path. Pin to a specific commit (not `main`) for reproducibility — refresh
  # on bumps by updating `rev`, setting `hash = "";`, and rebuilding.
  litellmRaw = fetchurl {
    url = "https://raw.githubusercontent.com/BerriAI/litellm/d9661222492a098555f40cb8b50014054bea5ab8/model_prices_and_context_window.json";
    hash = "sha256-jV/bRDNx+DNMKMsP9kvw82rRNexvdm7sdnzGLTt/gJI=";
  };
in
buildNpmPackage {
  pname = "codeburn";
  inherit version src;

  nodejs = nodejs_22;

  npmDepsHash = "sha256-t36Q1NLjY0I//m/XJrPdxe0a6LvYqgY5+HOphMzlE5M=";

  # Redirect bundle-litellm.mjs's runtime `fetch()` to read the vendored
  # snapshot from the Nix store. The `if (!res.ok)` check stays as a no-op
  # because we shim `res` to `{ ok: true }`. `--replace-fail` ensures future
  # upstream restructurings of this script break the build loudly instead
  # of silently producing a stale snapshot.
  postPatch = ''
    substituteInPlace scripts/bundle-litellm.mjs \
      --replace-fail \
        "import { writeFileSync, mkdirSync } from 'fs'" \
        "import { writeFileSync, mkdirSync, readFileSync } from 'fs'"
    substituteInPlace scripts/bundle-litellm.mjs \
      --replace-fail \
        "const res = await fetch(LITELLM_URL)" \
        "const res = { ok: true }"
    substituteInPlace scripts/bundle-litellm.mjs \
      --replace-fail \
        "const data = await res.json()" \
        "const data = JSON.parse(readFileSync('${litellmRaw}', 'utf8'))"

    # dash/node_modules is provisioned offline in preBuild — drop the
    # in-script `npm install`, which would otherwise fail against the
    # root-only npm cache set up by npmConfigHook.
    substituteInPlace package.json \
      --replace-fail \
        "cd dash && npm install --no-audit --no-fund --silent && npm run build" \
        "cd dash && npm run build"
  '';

  # Install the dashboard's dependencies from the vendored cache. The cache is
  # copied out of the store because npm needs write access to it, and
  # npmConfigHook has already exported npm_config_offline=true for us.
  preBuild = ''
    cp -r ${dashDeps} "$TMPDIR/dash-npm-cache"
    chmod -R u+w "$TMPDIR/dash-npm-cache"
    npm_config_cache="$TMPDIR/dash-npm-cache" \
      npm ci --prefix dash --ignore-scripts --no-audit --no-fund
  '';

  # tsup bundles src/cli.ts -> dist/cli.js with a #!/usr/bin/env node banner.
  # The package.json `bin` field points to dist/cli.js, and `files: ["dist"]`
  # means npm pack ships only that. buildNpmPackage's default install phase
  # (npm pack + npm install --global into $out) handles the bin wrapper and
  # patches the shebang to the nodejs derivation in the closure.
  npmBuildScript = "build";

  meta = with lib; {
    description = "See where your AI coding tokens go - by task, tool, model, and project";
    homepage = "https://github.com/getagentseal/codeburn";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "codeburn";
  };
}
