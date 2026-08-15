{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "freebuff";
  version = "0.0.149";

  src = fetchurl {
    url = "https://github.com/CodebuffAI/codebuff-community/releases/download/freebuff-v${version}/freebuff-linux-x64.tar.gz";
    hash = "sha256-PxHyw7Rx8V29qYI90ftSXWe18WwCk755bz/BUmczyj0=";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp freebuff $out/bin/
    cp tree-sitter.wasm $out/bin/
    chmod +x $out/bin/freebuff
  '';

  dontFixup = true;

  meta = with lib; {
    description = "The world's strongest free coding agent";
    homepage = "https://freebuff.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "freebuff";
  };
}
