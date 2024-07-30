#ohmyzsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"
plugins=(git kubectl)

source <(kubectl completion zsh)