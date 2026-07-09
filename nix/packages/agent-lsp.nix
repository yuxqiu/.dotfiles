{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "agent-lsp";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "blackwell-systems";
    repo = "agent-lsp";
    rev = "v${version}";
    hash = "sha256-zFfI9PXHCO4YU9bBxqhh9aMeJbuAqjgPIR+RDxgUSXA=";
  };

  vendorHash = "sha256-bO3bqHxMAroc50Tvd803w6UnxqswwcB5ux3LUAtfmmA=";

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
