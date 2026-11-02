#!/usr/bin/env bash
# ==============================================================================
#  Oh Your Zsh Uninstaller / Restorer
#  Safely restores your previous shell configuration.
# ==============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
RESET="\033[0m"

OYZ_DIR="${OYZ:-$HOME/.oh-your-zsh}"
ZSHRC="$HOME/.zshrc"

printf "${CYAN}${BOLD}Oh Your Zsh Uninstaller${RESET}\n\n"

# 1. Look for pre-oh-your-zsh backup files
LATEST_BACKUP=$(ls -t "$HOME"/.zshrc.pre-oh-your-zsh.* 2>/dev/null | head -n 1 || true)

if [ -n "$LATEST_BACKUP" ] && [ -f "$LATEST_BACKUP" ]; then
  printf "${CYAN}● Found backup of your previous configuration:${RESET} %s\n" "$LATEST_BACKUP"
  printf "  Restoring %s to ~/.zshrc...\n" "$LATEST_BACKUP"
  cp "$LATEST_BACKUP" "$ZSHRC"
  printf "${GREEN}✔ ~/.zshrc restored from backup!${RESET}\n\n"
elif [ -f "$ZSHRC" ]; then
  # Re-enable commented Oh My Zsh lines and remove Oh Your Zsh block
  printf "${YELLOW}● No automatic backup found. Cleaning up ~/.zshrc manually...${RESET}\n"
  TEMP_ZSHRC="$(mktemp)"
  awk '
    /^# \[Disabled for Oh Your Zsh\] / {
      sub(/^# \[Disabled for Oh Your Zsh\] /, "")
      print
      next
    }
    /^# =+$/ {
      next
    }
    /^# Oh Your Zsh/ {
      next
    }
    /^(export OYZ=|source.*oh-your-zsh\.zsh)/ {
      next
    }
    { print }
  ' "$ZSHRC" > "$TEMP_ZSHRC"
  mv "$TEMP_ZSHRC" "$ZSHRC"
  printf "${GREEN}✔ Cleaned Oh Your Zsh entries and re-enabled previous settings in ~/.zshrc${RESET}\n\n"
fi

# 2. Offer to remove ~/.oh-your-zsh directory
if [ -d "$OYZ_DIR" ]; then
  printf "${YELLOW}● Removing %s...${RESET}\n" "$OYZ_DIR"
  rm -rf "$OYZ_DIR"
  printf "${GREEN}✔ Removed %s${RESET}\n" "$OYZ_DIR"
fi

printf "\n${GREEN}${BOLD}✔ Uninstallation complete.${RESET} Run ${BOLD}exec zsh${RESET} to reload your shell.\n"
