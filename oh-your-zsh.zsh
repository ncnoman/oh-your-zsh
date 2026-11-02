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

# Ensure Homebrew environment is loaded on macOS if available
if (( ! $+commands[brew] )) && [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif (( ! $+commands[brew] )) && [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Enable command substitution and parameter expansion in prompts
setopt prompt_subst

# Tell Python's activate script NOT to inject the plain text prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# ------------------------------------------------------------------------------
# Adaptive Wedge / Block Engine
# Automatically uses native angled wedges (◥, ◣, ◣) on terminals that render
# geometric primitives edge-to-edge (iTerm2, Ghostty, WezTerm, Kitty), and
# falls back to pure full-height ANSI color blocks on terminals where standard
# fonts leave vertical gaps (Terminal.app, VS Code, Zed, Alacritty).
#
# Override anytime in ~/.zshrc with:
#   export OYZ_STYLE="wedges"  (force angled wedges)
#   export OYZ_STYLE="blocks"  (force flat ANSI blocks)
# ------------------------------------------------------------------------------
if [[ "$OYZ_STYLE" == "wedges" ]] || { [[ "$OYZ_STYLE" != "blocks" ]] && {
     [[ "$TERM_PROGRAM" == "iTerm.app" ]] || [[ -n "$ITERM_SESSION_ID" ]] ||
     [[ "$TERM_PROGRAM" == "ghostty" ]]   || [[ -n "$GHOSTTY_RESOURCES_DIR" ]] ||
     [[ "$TERM_PROGRAM" == "WezTerm" ]]   || [[ -n "$WEZTERM_EXECUTABLE" ]] ||
     [[ "$TERM" == "xterm-kitty" ]]       || [[ -n "$KITTY_PID" ]];
   }; }; then
  START_WEDGE="${OYZ_START_WEDGE:-◥}"
  DIVIDER="${OYZ_DIVIDER:-◣}"
  END_WEDGE="${OYZ_END_WEDGE:-◣}"
else
  START_WEDGE="${OYZ_START_WEDGE:-}"
  DIVIDER="${OYZ_DIVIDER:-}"
  END_WEDGE="${OYZ_END_WEDGE:-}"
fi

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

    # Start the prompt with the Pink block and transition into Directory block
    print -n "%{%F{$BG_VENV}%}$START_WEDGE%{%K{$BG_VENV}%}%{%F{$FG}%}[$venv_name]"
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

  # 4. Clean two-line break
  print -n "\n > "
}

# Attach prompt generator
PROMPT='$(build_prompt)'

# Make it so pasting into terminal doesn't highlight pasted text
# Eliminates bracketed paste artifacting and visual clutter
zle_highlight+=(paste:none)

# Optional lightweight plugin loader (zero-mystery, opt-in)
# Scoped in an anonymous function to avoid printing variable assignments
if [[ -n "${plugins[*]}" ]]; then
  () {
    local plugin
    for plugin in "${plugins[@]}"; do
      if [[ -f "$OYZ/plugins/$plugin/$plugin.plugin.zsh" ]]; then
        source "$OYZ/plugins/$plugin/$plugin.plugin.zsh"
      elif [[ -f "$OYZ/custom/plugins/$plugin/$plugin.plugin.zsh" ]]; then
        source "$OYZ/custom/plugins/$plugin/$plugin.plugin.zsh"
      fi
    done
  }
fi

# Convenience helper functions
oyz_reload() {
  source "$HOME/.zshrc"
  echo "✔ oh-your-zsh reloaded successfully"
}

oyz_version() {
  local commit
  commit=$(command git -C "$OYZ" rev-parse --short HEAD 2>/dev/null || echo "release")
  echo "oh-your-zsh version 1.2.0 ($commit)"
}
