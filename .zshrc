export TERM="xterm-256color"
export ZSH="/Users/derekwiers/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi

export PATH=/Users/derekwiers/.local/bin:/usr/local/bin:$HOME/bin:$PATH

function powerline_precmd() {
    PS1="$($GOPATH/bin/powerline-go -cwd-max-depth 9 -newline -hostname-only-if-ssh -error $? -shell zsh)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

source $ZSH/oh-my-zsh.sh
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

export CLICOLOR=1
export LSCOLORS=GxBxhxDxfxhxhxhxhxcxcx
export HOMEBREW_GITHUB_API_TOKEN="67569db015ca2a14e9bcf532d55f9a07a4bd806d"

alias src="source ~/.zshrc"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias less="less -gJmNQRu"
alias date=gdate

. $HOME/.ghcup/env
export GOPATH="${HOME}/env/go"
export PATH="${PATH}:${HOME}/env/go/bin"
alias dc="docker-compose"
alias aws-login='eval $(aws ecr get-login --no-include-email)'
alias zedit="vim ~/.zshrc"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
export JAVA_HOME="/usr/local/Cellar/openjdk/14.0.1"

function racd () {
	cd $(ra "$1")
}
set -o noclobber
export PATH=$PATH:$HOME/.emacs.d/bin
