#!/usr/bin/env bash
# ==============================================================================
#  Oh Your Zsh Installer
#  Non-destructive, zero-dependency installation script.
# ==============================================================================

set -e

# ANSI Color codes
BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
RESET="\033[0m"

OYZ_DIR="${OYZ:-$HOME/.oh-your-zsh}"
REPO_URL="https://github.com/ncnoman/oh-your-zsh.git"

printf "${CYAN}${BOLD}"
cat << 'EOF'
      ____  __       __  __                  ____       __  
     / __ \/ /_     / / / /___  __  _______ /_  / _____/ /_ 
    / / / / __ \   / / / / __ \/ / / / ___/  / / / ___/ __ \
   / /_/ / / / /  / /_/ / /_/ / /_/ / /     / /_(__  ) / / /
   \____/_/ /_/   \____/\____/\__,_/_/     /___/____/_/ /_/ 

EOF
printf "${RESET}"
printf "${BOLD}Zero-dependency. Zero-mystery. Instant startup.${RESET}\n\n"

# 1. Clone or update repository
if [ -d "$OYZ_DIR/.git" ]; then
  printf "${YELLOW}● Existing installation found at %s. Pulling latest updates...${RESET}\n" "$OYZ_DIR"
  git -C "$OYZ_DIR" pull --quiet
else
  # If running from inside a cloned local repository
  CURRENT_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "$CURRENT_SCRIPT_DIR/oh-your-zsh.zsh" ] && [ "$CURRENT_SCRIPT_DIR" != "$OYZ_DIR" ]; then
    printf "${CYAN}● Installing from local repository to %s...${RESET}\n" "$OYZ_DIR"
    mkdir -p "$OYZ_DIR"
    cp -R "$CURRENT_SCRIPT_DIR/"* "$OYZ_DIR/"
  else
    printf "${CYAN}● Cloning oh-your-zsh to %s...${RESET}\n" "$OYZ_DIR"
    git clone --depth=1 "$REPO_URL" "$OYZ_DIR"
  fi
fi

# 2. Non-destructive ~/.zshrc handling
ZSHRC="$HOME/.zshrc"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

if [ -f "$ZSHRC" ]; then
  BACKUP="$HOME/.zshrc.pre-oh-your-zsh.$TIMESTAMP"
  printf "${CYAN}● Backing up your current ~/.zshrc to ${BOLD}%s${RESET}\n" "$BACKUP"
  cp "$ZSHRC" "$BACKUP"

  # Check if Oh My Zsh is currently loaded
  if grep -q "oh-my-zsh.sh" "$ZSHRC"; then
    printf "${YELLOW}● Oh My Zsh detected in your ~/.zshrc.${RESET}\n"
    printf "  Non-destructively disabling Oh My Zsh and activating Oh Your Zsh...\n"
    printf "  ${GREEN}Note: Your ~/.oh-my-zsh folder was NOT touched. You can switch back anytime!${RESET}\n"

    # Comment out oh-my-zsh source line and prepend Oh Your Zsh block
    TEMP_ZSHRC="$(mktemp)"
    awk '
      /^([[:space:]]*)(source|\.)[[:space:]]+.*oh-my-zsh\.sh/ {
        print "# [Disabled for Oh Your Zsh] " $0
        next
      }
      /^([[:space:]]*)ZSH_THEME=/ {
        print "# [Disabled for Oh Your Zsh] " $0
        next
      }
      { print }
    ' "$ZSHRC" > "$TEMP_ZSHRC"

    # Append Oh Your Zsh loader if not already present
    if ! grep -q "oh-your-zsh.zsh" "$TEMP_ZSHRC"; then
      cat << 'EOF' >> "$TEMP_ZSHRC"

# ==============================================================================
# Oh Your Zsh (OYZ) - Zero-Mystery Shell Engine
# To switch back to Oh My Zsh, comment out the line below and uncomment OMZ above.
# ==============================================================================
export OYZ="$HOME/.oh-your-zsh"
source "$OYZ/oh-your-zsh.zsh"
EOF
    fi
    mv "$TEMP_ZSHRC" "$ZSHRC"
  elif ! grep -q "oh-your-zsh.zsh" "$ZSHRC"; then
    printf "${CYAN}● Appending oh-your-zsh configuration to ~/.zshrc...${RESET}\n"
    cat << 'EOF' >> "$ZSHRC"

# ==============================================================================
# Oh Your Zsh (OYZ) - Zero-Mystery Shell Engine
# ==============================================================================
export OYZ="$HOME/.oh-your-zsh"
source "$OYZ/oh-your-zsh.zsh"
EOF
  else
    printf "${GREEN}● Oh Your Zsh is already configured in ~/.zshrc.${RESET}\n"
  fi
else
  printf "${CYAN}● Creating fresh ~/.zshrc from template...${RESET}\n"
  cp "$OYZ_DIR/templates/zshrc.zsh-template" "$ZSHRC"
fi

printf "\n${GREEN}${BOLD}✔ Oh Your Zsh installed successfully!${RESET}\n\n"
printf "To start using it immediately, run:\n"
printf "  ${BOLD}exec zsh${RESET}\n\n"
printf "Or test it right now in this session:\n"
printf "  ${BOLD}source ~/.zshrc${RESET}\n\n"
