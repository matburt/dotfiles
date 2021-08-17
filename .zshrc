export ZSH="/home/mjones/.oh-my-zsh"

# WSL
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

HISTFILE=$HOME/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt hist_ignore_all_dups

export PATH=$PATH:~/.poetry/bin:~/go/bin
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/go/bin:$HOME/bin:$PATH"

export LESS=FRSXQ

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='ag --hidden --follow'

ZSH_THEME="lukerandall"
plugins=(git ag fzf python kubectl)
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="code -n -w"
else
  export EDITOR="mg"
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

