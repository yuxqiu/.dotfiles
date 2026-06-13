{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "opencode-goal";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "willytop8";
    repo = "OpenCode-goal-plugin";
    rev = "v${version}";
    hash = "sha256-jkwzT0kEyOwkXZO2HJdM3aBAcg/Idal8Z/QwbF3YgME=";
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
