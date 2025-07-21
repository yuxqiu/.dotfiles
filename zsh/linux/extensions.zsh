# fzf
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# use zsh-autosuggest async mode
ZSH_AUTOSUGGEST_USE_ASYNC=1

source "$DOTFILES/zsh/linux/pyenv.zsh"
