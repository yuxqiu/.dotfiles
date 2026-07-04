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
    rev = "ba7ef8cac985fbfa99cbe16f702b0b016c267a17"; # follow:branch main
    hash = "sha256-LxkGjcnTYi89zGRSdtkH6So4wArKcXE7xbhozMeqfQ0=";
  };

  meta = {
    description = "Context-aware paste indentation for Neovim";
    homepage = "https://github.com/nemanjamalesija/smart-paste.nvim";
    license = lib.licenses.mit;
  };
}
