# If you come from bash you might have to change your $PATH.
export TERM="xterm-256color"

# fix homebrew instaled completion
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  golang
#  kubectl
)

function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

envup() {
  local file=$([ -z "$1" ] && echo ".env" || echo "$1")

  if [ -f $file ]; then
    set -a
    source $file
    set +a
  else
    echo "No $file file found" 1>&2
    return 1
  fi
}

export PATH=$PATH:~/bin
export EDITOR=nvim

source $ZSH/oh-my-zsh.sh

# if gpg password prompt is missbehaving try this
#export GPG_TTY=$(tty)

autoload -U compinit && compinit

if (( $+commands[nvim] )); then
  alias vim=nvim
fi

alias reload-rc="source ~/.zshrc"
alias kc=kubectl
alias fast-ssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias config="alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U +X bashcompinit && bashcompinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.kube/completion.zsh.inc ] && source ~/.kube/completion.zsh.inc
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
