# ==============================================================================
#  Oh Your Zsh - Common Aliases Plugin
#  Sensible, lightweight navigation and utility aliases.
# ==============================================================================

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory listing with colors
if [[ "$OSTYPE" == darwin* ]]; then
  alias l='ls -lhG'
  alias ll='ls -lhG'
  alias la='ls -lahG'
else
  alias l='ls -lh --color=auto'
  alias ll='ls -lh --color=auto'
  alias la='ls -lah --color=auto'
fi

# Safety & clarity
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Fast search
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# History helpers
alias h='history'
alias hg='history | grep'
