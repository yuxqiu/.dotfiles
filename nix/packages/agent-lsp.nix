{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "agent-lsp";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "blackwell-systems";
    repo = "agent-lsp";
    rev = "v${version}";
    hash = "sha256-rCri95j3DAcZF7LHOTrkCwlRhQWfEIaaUhCVNiWuVZg=";
  };

  vendorHash = "sha256-JTXCizXm2i4sSWC5Ffo+iMXfNUYIi5aZql0Nj70Yvx4=";

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
