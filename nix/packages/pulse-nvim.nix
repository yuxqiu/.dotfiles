{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin rec {
  pname = "pulse-nvim";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "willyelm";
    repo = "pulse.nvim";
    rev = "v${version}";
    hash = "sha256-ZtFy3MT1yRjECnXK+1hZtknFTu7Qk51wFdGaEiEJqf8=";
  };

  meta = {
    description = "A single command palette with prefix based pickers for Neovim";
    homepage = "https://github.com/willyelm/pulse.nvim";
    license = lib.licenses.mit;
  };
}
