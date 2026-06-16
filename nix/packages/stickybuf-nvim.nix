{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin rec {
  pname = "stickybuf-nvim";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "stevearc";
    repo = "stickybuf.nvim";
    rev = "v${version}";
    hash = "sha256-WuT3gaYW4bV3hWoQ9Gj1uXkH+/W1hoLsTnh+j27otIo=";
  };

  meta = {
    description = "Neovim plugin for locking a buffer to a window";
    homepage = "https://github.com/stevearc/stickybuf.nvim";
    license = lib.licenses.mit;
  };
}
