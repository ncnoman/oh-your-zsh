# ==============================================================================
#  Oh Your Zsh - Git Plugin
#  Zero-mystery, highly useful, non-colliding Git aliases.
# ==============================================================================

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'

alias gc='git commit -m'
alias gca='git commit -a -m'
alias gcam='git commit --amend'
alias gce='git commit --allow-empty -m'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gsc='git switch -c'

alias gd='git diff'
alias gds='git diff --staged'

alias gl='git log --oneline --graph --decorate'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gpr='git pull --rebase'

alias gst='git status'
alias gss='git status -s'

alias gsta='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstd='git stash drop'
