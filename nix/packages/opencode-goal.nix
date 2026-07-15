{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "opencode-goal";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "willytop8";
    repo = "OpenCode-goal-plugin";
    rev = "v${version}";
    hash = "sha256-AJ7eL6JwD3GjWOi0Ox+B9+B3ADsAQH2FoWmNI78335w=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencode-goal-plugin
    cp src/goal-plugin.js $out/lib/opencode-goal-plugin/
    runHook postInstall
  '';

  meta = {
    description = "Session-scoped /goal workflow for OpenCode";
    homepage = "https://github.com/willytop8/OpenCode-goal-plugin";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
