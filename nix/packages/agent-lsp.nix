{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "agent-lsp";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "blackwell-systems";
    repo = "agent-lsp";
    rev = "v${version}";
    hash = "sha256-l04uuMP4giVUykDpR4mWK2P+Tkj/E16EqDuMOEYNa8U=";
  };

  vendorHash = "sha256-/y+v/aCzqigLut3kljCwa5iMD5yMLK1L5ul9ue8YFqU=";

  subPackages = [ "cmd/agent-lsp" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    description = "MCP server exposing 50+ language server protocol tools to AI agents";
    homepage = "https://github.com/blackwell-systems/agent-lsp";
    license = lib.licenses.mit;
    mainProgram = "agent-lsp";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
