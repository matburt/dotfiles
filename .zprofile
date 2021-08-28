export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.poetry/bin:$HOME/.cargo/bin:$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Auto-start ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  # Check for a currently running instance of the agent
  RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
  if [ "$RUNNING_AGENT" = "0" ]; then
    # Launch a new instance of the agent
    ssh-agent -s &> ~/.ssh/ssh-agent
  fi
  eval `cat ~/.ssh/ssh-agent`
fi
