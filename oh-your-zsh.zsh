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

# ------------------------------------------------------------------------------
# Prompt Style Configuration
# Styles:
#   - "wedges"  (Default) Flagship native angled text pointers (◤, ◣, ◥).
#               Parallel forward-slanted chevrons, 100% core-safe Unicode.
#   - "blocks"  Pure ANSI full-height solid color blocks.
#   - "pills"   Discrete tag badges separated by terminal background spacing.
#   - "slanted" Classic Powerline chevrons (requires patched Nerd Font).
# ------------------------------------------------------------------------------
OYZ_STYLE="${OYZ_STYLE:-wedges}"

# Native angled text pointers (100% core-safe, zero font dependencies)
START_WEDGE="${OYZ_START_WEDGE:-◤}"
DIVIDER="${OYZ_DIVIDER:-◣}"
END_WEDGE="${OYZ_END_WEDGE:-◥}"

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
  local style="${OYZ_STYLE:-wedges}"

  # 1. Python Virtual Environment Segment
  local venv_name=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv_name="${VIRTUAL_ENV:t}"
  fi

  # 2. Process Dynamic Git State Data
  local git_data=$(get_git_state)
  local git_state="" git_icon="" git_name="" git_bg=""
  if [[ -n "$git_data" ]]; then
    local parts=("${(@s.:.)git_data}")
    git_state="${parts[1]}"
    git_icon="${parts[2]}"
    git_name="${parts[3]}"
    if [[ "$git_state" == "dirty" ]]; then
      git_bg="$BG_GIT_DIRTY"
    else
      git_bg="$BG_GIT_CLEAN"
    fi
  fi

  # 3. Render Based on Selected Style
  case "$style" in
    wedges|triangles)
      # Flagship Angled Text Pointers (◤, ◣, ◥)
      # Perfectly parallel forward-slanted chevrons
      if [[ -n "$venv_name" ]]; then
        print -n "%{%F{$BG_VENV}%}$START_WEDGE%{%K{$BG_VENV}%}%{%F{$FG}%}[$venv_name]"
        print -n "%{%K{$BG_DIR}%F{$BG_VENV}%}$DIVIDER%{%F{$FG}%} %~ "
      else
        print -n "%{%F{$BG_DIR}%}$START_WEDGE%{%K{$BG_DIR}%}%{%F{$FG}%} %~ "
      fi

      if [[ -n "$git_data" ]]; then
        print -n "%{%K{$git_bg}%F{$BG_DIR}%}$DIVIDER%{%F{$FG}%} $git_icon $git_name "
        print -n "%{%k%f%}%{%F{$git_bg}%}$END_WEDGE%{%k%f%} "
      else
        print -n "%{%k%f%}%{%F{$BG_DIR}%}$END_WEDGE%{%k%f%} "
      fi
      ;;

    blocks|pure|solid)
      # Pure ANSI background block switching
      # 100% full-height, zero font dependencies
      if [[ -n "$venv_name" ]]; then
        print -n "%{%K{$BG_VENV}%F{$FG%}%} [$venv_name] "
      fi

      print -n "%{%K{$BG_DIR}%F{$FG%}%} %~ "

      if [[ -n "$git_data" ]]; then
        print -n "%{%K{$git_bg}%F{$FG%}%} $git_icon $git_name "
      fi

      print -n "%{%k%f%}"
      ;;

    pills|badges)
      # Discrete pill badges separated by terminal background spaces
      if [[ -n "$venv_name" ]]; then
        print -n "%{%K{$BG_VENV}%F{$FG%}%} [$venv_name] %{%k%f%} "
      fi

      print -n "%{%K{$BG_DIR}%F{$FG%}%} %~ %{%k%f%}"

      if [[ -n "$git_data" ]]; then
        print -n " %{%K{$git_bg}%F{$FG%}%} $git_icon $git_name %{%k%f%}"
      fi
      ;;

    slanted|powerline)
      # Powerline chevrons () for users with patched Nerd Fonts
      local pl_sep=""
      if [[ -n "$venv_name" ]]; then
        print -n "%{%K{$BG_VENV}%F{$FG%}%} [$venv_name] "
        print -n "%{%K{$BG_DIR}%F{$BG_VENV}%}$pl_sep%{%F{$FG}%} %~ "
      else
        print -n "%{%K{$BG_DIR}%F{$FG%}%} %~ "
      fi

      if [[ -n "$git_data" ]]; then
        print -n "%{%K{$git_bg}%F{$BG_DIR}%}$pl_sep%{%F{$FG}%} $git_icon $git_name "
        print -n "%{%k%F{$git_bg}%}$pl_sep%{%k%f%} "
      else
        print -n "%{%k%F{$BG_DIR}%}$pl_sep%{%k%f%} "
      fi
      ;;
  esac

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
  echo "oh-your-zsh version 1.1.1 ($commit)"
}
