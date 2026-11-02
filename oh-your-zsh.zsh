#!/usr/bin/env zsh
# ==============================================================================
#  OH-YOUR-ZSH (OYZ)
#  The zero-dependency, zero-mystery, lightning-fast shell framework.
#  https://github.com/ncnoman/oh-your-zsh
# ==============================================================================

# Determine installation directory
if [[ -z "$OYZ" ]]; then
  export OYZ="${0:A:h}"
fi

# Ensure Homebrew environment is loaded on macOS Apple Silicon if available
if (( ! $+commands[brew] )) && [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif (( ! $+commands[brew] )) && [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Enable command substitution and parameter expansion in prompts
setopt prompt_subst

# Tell Python's activate script NOT to inject the plain text prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Native angled text pointers (100% core-safe, zero font dependencies)
# Renders identically in all terminals without requiring patched Nerd/Powerline fonts.
START_WEDGE="${OYZ_START_WEDGE:-◥}"
DIVIDER="${OYZ_DIVIDER:-◣}"
END_WEDGE="${OYZ_END_WEDGE:-◣}"

# Colors (256-color palette compatible with all terminal emulators)
# Easily override any of these in your ~/.zshrc prior to sourcing oh-your-zsh
FG="${OYZ_FG:-0}"
BG_VENV="${OYZ_BG_VENV:-201}"
BG_DIR="${OYZ_BG_DIR:-33}"
BG_GIT_CLEAN="${OYZ_BG_GIT_CLEAN:-120}"
BG_GIT_DIRTY="${OYZ_BG_GIT_DIRTY:-208}"

# Optional theme loader
if [[ -n "$OYZ_THEME" ]] && [[ -f "$OYZ/themes/${OYZ_THEME}.zsh" ]]; then
  source "$OYZ/themes/${OYZ_THEME}.zsh"
fi

# Advanced state engine to handle git status, colors, and symbols
# Fast, lightweight, pure Git porcelain - no heavy external binaries
get_git_state() {
  # 1. Grab raw branch name or detached HEAD hash
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null)

  if [[ -z "$branch" ]]; then
    # Detached HEAD state (shows commit hash instead of branch name)
    branch=$(command git rev-parse --short HEAD 2>/dev/null) || return
    # Detached state uses a native right-pointing arrow symbol
    local icon="${OYZ_GIT_DETACHED_ICON:-->}"
  else
    # Active branch uses a native branching tracks symbol
    local icon="${OYZ_GIT_BRANCH_ICON:-⑂}"
  fi

  # 2. Check if the index or working tree has uncommitted modifications
  local dirty=""
  if [[ -n "$(command git status --porcelain 2>/dev/null)" ]]; then
    # Dirty state appends the official Git status modifier flag
    dirty="${OYZ_GIT_DIRTY_FLAG:-±}"
    echo "dirty:${icon}:${branch} ${dirty}"
  else
    echo "clean:${icon}:${branch}"
  fi
}

# Core prompt renderer
build_prompt() {
  # 0. Dynamic Virtual Environment Segment (Pink Block)
  if [[ -n "$VIRTUAL_ENV" ]]; then
    # Extract just the folder name of the current environment (e.g., "foo")
    local venv_name="${VIRTUAL_ENV:t}"

    # Start the prompt with the Pink block
    print -n "%{%F{$BG_VENV}%}$START_WEDGE%{%K{$BG_VENV}%}%{%F{$FG}%}[$venv_name]"
    # Connect pink block to cyan directory block with angled divider
    print -n "%{%K{$BG_DIR}%F{$BG_VENV}%}$DIVIDER%{%F{$FG}%} %~ "
  else
    # 1. Directory Block (Cyan background)
    print -n "%{%F{$BG_DIR}%}$START_WEDGE%{%K{$BG_DIR}%}%{%F{$FG}%} %~ "
  fi

  # 2. Process Dynamic Git State Data
  local git_data=$(get_git_state)
  if [[ -n "$git_data" ]]; then
    # Split the returned string by colons
    local parts=("${(@s.:.)git_data}")
    local state="${parts[1]}"
    local icon="${parts[2]}"
    local name="${parts[3]}"

    # 3. Pick layout and coloring depending on if files are modified
    if [[ "$state" == "dirty" ]]; then
      # Vibrant Orange background with custom state icons
      print -n "%{%K{$BG_GIT_DIRTY}%F{$BG_DIR}%}$DIVIDER%{%F{$FG}%} $icon $name "
      print -n "%{%k%f%}%{%F{$BG_GIT_DIRTY}%}$END_WEDGE%{%k%f%} "
    else
      # Lime Green background with custom state icons
      print -n "%{%K{$BG_GIT_CLEAN}%F{$BG_DIR}%}$DIVIDER%{%F{$FG}%} $icon $name "
      print -n "%{%k%f%}%{%F{$BG_GIT_CLEAN}%}$END_WEDGE%{%k%f%} "
    fi
  else
    # Terminate Directory Block cleanly if outside a repo:
    # Hard-clears background block, then colors the floating character Cyan
    print -n "%{%k%f%}%{%F{$BG_DIR}%}$END_WEDGE%{%k%f%} "
  fi

  # 4. Your preferred clean two-line break
  print -n "\n > "
}

# Attach prompt generator
PROMPT='$(build_prompt)'

# Make it so pasting into terminal doesn't highlight pasted text
# Eliminates bracketed paste artifacting and visual clutter
zle_highlight+=(paste:none)

# Optional lightweight plugin loader (zero-mystery, opt-in)
# If user specifies plugins=(git common-aliases) in their .zshrc
if [[ -n "${plugins[*]}" ]]; then
  local plugin
  for plugin in "${plugins[@]}"; do
    if [[ -f "$OYZ/plugins/$plugin/$plugin.plugin.zsh" ]]; then
      source "$OYZ/plugins/$plugin/$plugin.plugin.zsh"
    elif [[ -f "$OYZ/custom/plugins/$plugin/$plugin.plugin.zsh" ]]; then
      source "$OYZ/custom/plugins/$plugin/$plugin.plugin.zsh"
    fi
  done
fi

# Convenience helper functions
oyz_reload() {
  source "$HOME/.zshrc"
  echo "✔ oh-your-zsh reloaded successfully"
}

oyz_version() {
  local commit
  commit=$(command git -C "$OYZ" rev-parse --short HEAD 2>/dev/null || echo "release")
  echo "oh-your-zsh version 1.0.0 ($commit)"
}
