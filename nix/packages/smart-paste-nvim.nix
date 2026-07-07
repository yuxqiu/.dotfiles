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
    rev = "7eef31499d910959fe94bb1a99dcdae6eb30f90b"; # follow:branch main
    hash = "sha256-N5R3E2aOm8Fz7OIqah05pZYn+MT3tnPxRN6KA/7Y+bM=";
  };

  meta = {
    description = "Context-aware paste indentation for Neovim";
    homepage = "https://github.com/nemanjamalesija/smart-paste.nvim";
    license = lib.licenses.mit;
  };
}
