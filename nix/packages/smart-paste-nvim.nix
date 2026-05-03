{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "smart-paste-nvim";
  version = "0-unstable-2026-02-08";

  src = fetchFromGitHub {
    owner = "nemanjamalesija";
    repo = "smart-paste.nvim";
    rev = "328f90f7f4535f58d5bd987edb48588836efdecc";
    hash = "sha256-aJIiei3YCFKKD9KzytifOjO+KIhhL5EFdfVkpAv2hJc=";
  };

  meta = {
    description = "Context-aware paste indentation for Neovim";
    homepage = "https://github.com/nemanjamalesija/smart-paste.nvim";
    license = lib.licenses.mit;
  };
}

