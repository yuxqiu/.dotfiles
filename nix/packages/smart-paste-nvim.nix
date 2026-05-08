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
    rev = "7a461d3d83a6bee199d3f1c0b177f7f3e22fa371"; # follow:branch main
    hash = "sha256-aJIiei3YCFKKD9KzytifOjO+KIhhL5EFdfVkpAv2hJc=";
  };

  meta = {
    description = "Context-aware paste indentation for Neovim";
    homepage = "https://github.com/nemanjamalesija/smart-paste.nvim";
    license = lib.licenses.mit;
  };
}
