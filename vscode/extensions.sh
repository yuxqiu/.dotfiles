#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "$(realpath "$0")")
EXPORT_SCRIPT="$SCRIPT_DIR/export.sh"

# List of extensions to install
EXTENSIONS=(
  albert.tabout
  antfu.icons-carbon
  asvetliakov.vscode-neovim
  be5invis.vscode-custom-css
  bierner.markdown-mermaid
  copilot-arena.copilot-arena
  cschlosser.doxdocgen
  editorconfig.editorconfig
  foam.foam-vscode
  gruntfuggly.todo-tree
  hars.cppsnippets
  james-yu.latex-workshop
  jasonlhy.hungry-delete
  juanblanco.solidity
  llvm-vs-code-extensions.vscode-clangd
  ms-azuretools.vscode-containers
  ms-azuretools.vscode-docker
  ms-python.black-formatter
  ms-python.debugpy
  ms-python.python
  ms-python.vscode-pylance
  ms-python.vscode-python-envs
  ms-toolsai.jupyter
  ms-toolsai.jupyter-keymap
  ms-toolsai.jupyter-renderers
  ms-toolsai.vscode-jupyter-cell-tags
  ms-toolsai.vscode-jupyter-slideshow
  ms-vscode.cmake-tools
  ms-vscode.hexeditor
  ms-vscode.remote-explorer
  ms-vscode-remote.remote-containers
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-ssh-edit
  ms-vsliveshare.vsliveshare
  myriad-dreamin.tinymist
  nmsmith89.incrementor
  redhat.java
  redhat.vscode-yaml
  remisa.shellman
  robole.markdown-shortcuts
  rust-lang.rust-analyzer
  streetsidesoftware.code-spell-checker
  tamasfe.even-better-toml
  thomanq.math-snippets
  twxs.cmake
  usernamehw.errorlens
  vadimcn.vscode-lldb
  vscjava.vscode-java-debug
  vscjava.vscode-java-test
  vscjava.vscode-maven
  xaver.clang-format
  yfzhao.hscopes-booster
  yfzhao.ultra-math-preview
  yzhang.markdown-all-in-one
  zhuangtongfa.material-theme
)

# Get installed extensions
if [ -f "$EXPORT_SCRIPT" ]; then
  INSTALLED_EXTENSIONS=$(bash "$EXPORT_SCRIPT" --list-only)
else
  echo "Error: $EXPORT_SCRIPT not found."
  exit 1
fi

# Install only not-yet-installed extensions
for ext in "${EXTENSIONS[@]}"; do
  if ! echo "$INSTALLED_EXTENSIONS" | grep -q "^$ext$"; then
    echo "Installing extension: $ext"
    code --install-extension "$ext"
  else
    echo "Extension $ext already installed."
  fi
done

echo "Extension installation check completed."
