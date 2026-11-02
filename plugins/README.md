# Oh Your Zsh Plugins

## Philosophy
Oh My Zsh ships with over 300 plugins containing thousands of lines of slow, opaque shell scripts that team leads have to spend hours debugging when something breaks.

In **Oh Your Zsh**, plugins follow three strict rules:
1. **Zero External Dependencies**: Must run on pure Zsh builtins and standard tools (`git`, `ls`, etc.).
2. **Zero Mystery**: Every plugin file is short, transparent, and auditable in 30 seconds.
3. **Zero Startup Lag**: Plugins only define aliases or lightweight functions; they never spawn subshells or run network calls on shell startup.

## Available Built-in Plugins

- `git`: Clean, practical, standard git aliases (`g`, `ga`, `gc`, `gst`, `gp`, `gl`, etc.).
- `common-aliases`: Essential navigation (`..`, `...`) and colorized `ls` / `grep` aliases.

## Enabling Plugins

In your `~/.zshrc`:

```zsh
plugins=(git common-aliases)

source "$HOME/.oh-your-zsh/oh-your-zsh.zsh"
```
