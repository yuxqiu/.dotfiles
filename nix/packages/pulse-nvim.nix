{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin rec {
  pname = "pulse-nvim";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "willyelm";
    repo = "pulse.nvim";
    rev = "v${version}";
    hash = "sha256-5zcrSuReP14xehMZ5+eySQNXmOYXtlHbPsZBVUmfFwQ=";
  };

  meta = {
    description = "A single command palette with prefix based pickers for Neovim";
    homepage = "https://github.com/willyelm/pulse.nvim";
    license = lib.licenses.mit;
  };
}
