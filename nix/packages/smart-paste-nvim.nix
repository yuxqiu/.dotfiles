{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "smart-paste-nvim";
  version = "0-unstable-2026-02-21";

  src = fetchFromGitHub {
    owner = "nemanjamalesija";
    repo = "smart-paste.nvim";
    rev = "85993bd97a5cb957a2cf6da573db0fdf5fc28c3c"; # follow:branch main
    hash = "sha256-dJQYIwz66Yf94Ft0x5oXbYm4fOyzTTf7qcIdCVQJL38=";
  };

  meta = {
    description = "Context-aware paste indentation for Neovim";
    homepage = "https://github.com/nemanjamalesija/smart-paste.nvim";
    license = lib.licenses.mit;
  };
}
