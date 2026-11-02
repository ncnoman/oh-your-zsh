<div align="center">

# ◤ Oh Your Zsh ◥

### The Zero-Dependency, Zero-Mystery Shell Engine for Zsh

**A fast, beautiful, angled prompt with zero font dependencies, zero black boxes, and sub-5ms startup times.**

Built to replace Oh My Zsh for developers and team leads who are tired of broken fonts, slow terminals, and mysterious configuration bugs.

---

</div>

```text
 Outside Git:
 ◤ ~/repos/my-service ◥ 
  > 

 Inside Git Repo (Clean working tree):
 ◤ ~/repos/my-service ◣ ⑂ main ◥ 
  > 

 Inside Git Repo (Modified / Uncommitted files):
 ◤ ~/repos/my-service ◣ ⑂ main ± ◥ 
  > 

 Inside Python Virtualenv:
 ◤[api-env]◣ ~/repos/my-service ◣ ⑂ feat/auth ± ◥ 
  > 
```

---

## 🎯 The Purpose: Why Oh Your Zsh?

If you have ever supported developers, maintained internal developer platforms, or managed a team's workstations, you know the **Oh My Zsh problem**:

1. **The Font Trap**: Themes like Agnoster or Powerlevel10k require custom patched Nerd Fonts (`Meslo`, `FiraCode NF`). As soon as an engineer SSHs into a remote VM, spins up a Docker container, opens a tmux pane, or uses a web terminal, their prompt breaks into ugly missing-character glyphs `[?]` and `?`.
2. **The "Black Box" Nightmare**: Oh My Zsh contains over **100,000 lines of code across 300+ plugins**. Obscure `precmd` hooks, magic paste handlers (`bracketed-paste-magic`), and auto-update daemons silently alter shell behavior. When a user reports "my terminal freezes when I paste a URL" or "my arrow keys stopped working", team leads waste hours untangling a web of scripts.
3. **Agonizing Startup Latency**: Spawning subshells, loading dozens of unneeded plugins, and bloated completion scripts frequently add **200ms to 1500ms+** to every single terminal tab or pane you open.

### The Oh Your Zsh Fix

* **100% Core-Safe Unicode**: Uses native Unicode angled text pointers (`◤`, `◣`, `◥`), branching tracks (`⑂`), detached state indicator (`->`), and Git status modifier (`±`). It renders identically and gorgeously in **any standard font** (SF Mono, Menlo, Consolas, Courier, DejaVu Sans) without downloading or patching fonts.
* **Zero Mystery (< 100 lines of code)**: The core engine is a single, clean, readable shell script. Any team lead or developer can audit the entire system in 2 minutes. There are no background daemons, no silent network requests, and no secret hook overrides.
* **Sub-5ms Instant Startup**: Pure native Zsh builtins and Git porcelain checks. No subshell cascades.
* **Dynamic Git & Python Virtualenv Awareness**: Instant branch/commit tracking, clean (lime green) vs dirty (orange) background transitions, and integrated virtual environment detection with `VIRTUAL_ENV_DISABLE_PROMPT=1`.
* **Fixes Terminal Glitches**: Permanently eliminates bracketed paste highlighting artifacts (`zle_highlight+=(paste:none)`).

---

## 🚀 Try Before You Buy (Non-Destructive Adoption)

You do **not** need to uninstall or delete Oh My Zsh to try Oh Your Zsh. You can test it safely in seconds without altering your machine.

### Method 1: The 5-Second Test Drive (Zero Files Modified)

Want to see how it looks and feels in your current terminal right now? Run this:

```zsh
git clone https://github.com/ncnoman/oh-your-zsh.git ~/.oh-your-zsh
source ~/.oh-your-zsh/oh-your-zsh.zsh
```

Your prompt instantly transforms. When you are done testing, simply close your terminal tab or run `exec zsh`, and you are immediately back to your old setup. Nothing was changed in your config files.

---

### Method 2: Side-by-Side Coexistence (Keep Both Installed)

You can keep your existing `~/.oh-my-zsh` folder intact and toggle between Oh My Zsh and Oh Your Zsh anytime with a single comment in your `~/.zshrc`.

1. Open your `~/.zshrc`:
   ```zsh
   nano ~/.zshrc
   ```

2. Temporarily comment out the Oh My Zsh loader and theme:
   ```zsh
   # --- Oh My Zsh (Commented out to test Oh Your Zsh) ---
   # export ZSH="$HOME/.oh-my-zsh"
   # ZSH_THEME="agnoster"
   # source $ZSH/oh-my-zsh.sh

   # --- Oh Your Zsh (Active) ---
   export OYZ="$HOME/.oh-your-zsh"
   source "$OYZ/oh-your-zsh.zsh"
   ```

3. Reload your terminal:
   ```zsh
   source ~/.zshrc
   ```

To switch back to Oh My Zsh at any point, simply re-comment the Oh Your Zsh lines and uncomment the Oh My Zsh lines.

---

### Method 3: Automated Non-Destructive Installer

Run the automated installer:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ncnoman/oh-your-zsh/main/install.sh)"
```

* **What it does safely**:
  1. Clones `oh-your-zsh` to `~/.oh-your-zsh`.
  2. Automatically creates a timestamped backup of your current `~/.zshrc` (e.g. `~/.zshrc.pre-oh-your-zsh.20261101`).
  3. Non-destructively comments out Oh My Zsh lines and enables Oh Your Zsh.
  4. **Never touches or deletes your `~/.oh-my-zsh` directory.**

To roll back at any time, run:
```bash
~/.oh-your-zsh/uninstall.sh
```

---

## 📦 Clean Migration (When You're Ready to Ditch OMZ)

Once you and your team are satisfied, remove the Oh My Zsh bloat entirely:

1. Remove the old Oh My Zsh directory:
   ```bash
   rm -rf ~/.oh-my-zsh
   ```

2. Use the clean, transparent Oh Your Zsh template:
   ```bash
   cp ~/.oh-your-zsh/templates/zshrc.zsh-template ~/.zshrc
   ```

Your `.zshrc` is now under 35 lines, clean, and easily understandable by anyone on your team.

---

## 🎨 Themes & Customization

Oh Your Zsh supports clean 256-color palettes. Unlike other frameworks that execute massive Lua/Rust configurations or opaque scripts, themes in Oh Your Zsh simply define 5 color variables.

### Built-in Palettes

Set `OYZ_THEME` in your `~/.zshrc` before sourcing `oh-your-zsh.zsh`:

```zsh
export OYZ_THEME="nord" # Options: default, nord, catppuccin, monokai, amber
source "$HOME/.oh-your-zsh/oh-your-zsh.zsh"
```

| Theme | Venv Block | Directory Block | Git Clean | Git Dirty |
| :--- | :--- | :--- | :--- | :--- |
| **`default`** | Magenta (`201`) | Dodger Cyan (`33`) | Lime Green (`120`) | Orange (`208`) |
| **`nord`** | Muted Purple (`139`) | Arctic Blue (`67`) | Nord Green (`150`) | Nord Amber (`179`) |
| **`catppuccin`** | Mauve (`212`) | Sapphire (`117`) | Mint Green (`151`) | Peach (`216`) |
| **`monokai`** | Pink (`197`) | Bright Cyan (`81`) | Monokai Green (`148`)| Vivid Orange (`208`) |
| **`amber`** | Gold (`214`) | Retro Amber (`178`)| Phosphor (`71`) | Rust (`166`) |

### Direct Color Overrides

You can override any individual color directly in your `~/.zshrc`:

```zsh
export OYZ_BG_DIR="39"         # Custom blue for directory
export OYZ_BG_GIT_CLEAN="76"    # Custom green for git clean
export OYZ_BG_GIT_DIRTY="196"   # Custom red for git dirty
source "$HOME/.oh-your-zsh/oh-your-zsh.zsh"
```

### Native Symbols Customization

All symbols can be overridden if your team prefers specific characters:

```zsh
export OYZ_START_WEDGE="◤"
export OYZ_DIVIDER="◣"
export OYZ_END_WEDGE="◥"
export OYZ_GIT_BRANCH_ICON="⑂"
export OYZ_GIT_DETACHED_ICON="->"
export OYZ_GIT_DIRTY_FLAG="±"
```

---

## ⚡ Performance Comparison

Tested on macOS Apple Silicon (M-series) and Linux (Ubuntu 24.04):

| Metric | Oh My Zsh (default + git) | Starship | **Oh Your Zsh** |
| :--- | :--- | :--- | :--- |
| **Cold Startup Time** | ~320ms – 1,100ms | ~45ms | **< 4ms** |
| **External Dependencies** | Git, Python/Ruby/Perl plugins, Curl | Rust binary + Nerd Font | **Zero (Native Zsh)** |
| **Font Requirements** | Patched Nerd Fonts / Powerline | Patched Nerd Fonts | **None (100% Core Safe)** |
| **Codebase Size** | > 100,000 lines | > 40,000 lines (compiled) | **< 100 lines (Readable)** |
| **Support Overhead** | High (plugins conflict, hooks clash) | Medium (binary updates) | **Zero (What you see is what runs)** |

---

## 🧩 Plugins (Zero-Mystery, Opt-in)

Oh My Zsh bundles hundreds of undocumented aliases and scripts. Oh Your Zsh ships only with essential, high-utility plugins where every line of code is transparent.

To enable plugins, add them to your `plugins` array before sourcing:

```zsh
plugins=(git common-aliases)
source "$HOME/.oh-your-zsh/oh-your-zsh.zsh"
```

* **`git`**: Common shortcuts without unexpected overrides:
  * `g` -> `git`, `gst` -> `git status`, `ga` -> `git add`, `gc` -> `git commit -m`
  * `gp` -> `git push`, `gpl` -> `git pull`, `gl` -> `git log --oneline --graph`
  * `gco` -> `git checkout`, `gcb` -> `git checkout -b`
* **`common-aliases`**:
  * `..`, `...`, `....` for fast directory navigation.
  * `ll`, `la`, `l` with sensible color flags on macOS (`-G`) and Linux (`--color=auto`).
  * Safety prompts on destructive commands (`rm -i`, `cp -i`, `mv -i`).

---

## 🛠 For Team Leads & System Administrators

### Why Team Leads Recommend Oh Your Zsh:
1. **No SSH Broken Fonts**: When team members SSH into production or staging nodes, their shell stays clean and legible.
2. **Deterministic Onboarding**: New developers don't spend 2 hours trying to configure iTerm2 font ligatures or fixing broken Oh My Zsh auto-updates.
3. **No Terminal Paste Corruption**: Zsh's `bracketed-paste-magic` often corrupts URLs or causes terminal freezes. Oh Your Zsh explicitly disables paste highlighting clutter via `zle_highlight+=(paste:none)`.
4. **Virtualenv Cleanliness**: Oh Your Zsh sets `export VIRTUAL_ENV_DISABLE_PROMPT=1` so Python's `source .venv/bin/activate` will never duplicate prompt strings.

---

## 📄 License

MIT License. Free for personal and commercial use. See [LICENSE](LICENSE) for details.
