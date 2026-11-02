# Oh Your Zsh Themes

Themes in `oh-your-zsh` are simple, zero-mystery color schemes. Unlike bloated prompt engines that run hundreds of lines of obscure code, an Oh Your Zsh theme is just a tiny file that defines 5 colors:

- `FG`: Foreground text color for blocks
- `BG_VENV`: Background color for Python virtual environment block
- `BG_DIR`: Background color for current working directory block
- `BG_GIT_CLEAN`: Background color when git repository has no uncommitted changes
- `BG_GIT_DIRTY`: Background color when git repository has uncommitted modifications

## Using a Theme

In your `~/.zshrc`, set `OYZ_THEME` before sourcing `oh-your-zsh.zsh`:

```zsh
export OYZ_THEME="nord" # Options: default, nord, catppuccin, monokai, amber
source "$HOME/.oh-your-zsh/oh-your-zsh.zsh"
```

## Creating Your Own Theme

Drop a `.zsh` file in `$HOME/.oh-your-zsh/themes/mytheme.zsh`:

```zsh
FG="0"
BG_VENV="201"
BG_DIR="45"
BG_GIT_CLEAN="46"
BG_GIT_DIRTY="202"
```

Then set `export OYZ_THEME="mytheme"` in your `~/.zshrc`.
