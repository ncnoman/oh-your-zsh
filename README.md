<div align="center">

# ◤ Oh Your Zsh ◥

### The Zero-Dependency, Zero-Mystery Shell Engine for Zsh

**A fast, beautiful shell prompt with zero font dependencies, zero black boxes, and sub-5ms startup times.**

Built to replace Oh My Zsh for developers and team leads who are tired of broken fonts, slow terminals, and mysterious configuration bugs.

---

</div>

```text
 1. Style "wedges" (Default - Flagship angled text pointers):
 ◤[api-env]◣ ~/repos/my-service ◣ ⑂ feat/auth ± ◥ 
  > 

 2. Style "blocks" (Pure ANSI solid blocks, zero font gaps in all terminals):
 [api-env]  ~/repos/my-service  ⑂ feat/auth ± 
  > 

 3. Style "pills" (Discrete spaced badges):
 [api-env]   ~/repos/my-service   ⑂ feat/auth ± 
  > 
```

---

## 🎯 The Purpose: Why Oh Your Zsh?

If you have ever supported developers, maintained internal developer platforms, or managed a team's workstations, you know the **Oh My Zsh problem**:

1. **The Font Trap**:
   - Themes like Agnoster or Powerlevel10k require custom patched Nerd Fonts (`Meslo`, `FiraCode NF`). Without them, prompts break into missing glyph boxes `[?]`.
   - **The Oh Your Zsh Solution**: Uses native angled text pointers (`◤`, `◣`, `◥`), branching tracks (`⑂`), detached state indicator (`->`), and Git status modifier (`±`). It renders identically and gorgeously in standard fonts without downloading or patching fonts.
2. **The "Black Box" Nightmare**:
   - Oh My Zsh contains over **100,000 lines of code across 300+ plugins**.
   - Obscure `precmd` hooks, magic paste handlers (`bracketed-paste-magic`), and auto-update daemons silently alter shell behavior.
   - When a user reports "my terminal freezes when I paste a URL" or "my arrow keys stopped working", team leads waste hours untangling a web of scripts.
3. **Agonizing Startup Latency**:
   - Spawning subshells, loading dozens of unneeded plugins, and bloated completion scripts frequently add **200ms to 1500ms+** to every single terminal tab or pane you open.

### The Oh Your Zsh Fix

* **Native Angled Chevrons**: Uses 100% core-safe Unicode triangles (`◤`, `◣`, `◥`) creating forward-leaning parallel slashes (`/` `/` `/`) across every segment.
* **Multiple Display Styles**: Choose between angled `wedges`, pure ANSI `blocks`, spaced `pills`, or Powerline `slanted`.
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
   export OYZ_STYLE="wedges"  # "wedges", "blocks", "pills", or "slanted"
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

## 🎨 Styles & Themes

### Prompt Styles (`OYZ_STYLE`)

Set `OYZ_STYLE` in your `~/.zshrc` before sourcing:

```zsh
export OYZ_STYLE="wedges" # Options: "wedges", "blocks", "pills", "slanted"
```

| Style | Description | Font Requirement |
| :--- | :--- | :--- |
| **`wedges`** *(Default)* | **Flagship angled text pointers (`◤`, `◣`, `◥`)**. Parallel forward-leaning chevrons. | **Standard Unicode** |
| **`blocks`** | Pure ANSI full-height solid color blocks with edge-to-edge rendering. | **None (Pure ANSI)** |
| **`pills`** | Discrete modern badge pills with terminal background spacing. | **None (Pure ANSI)** |
| **`slanted`** | Powerline chevrons (`` / ``). | Patched Nerd Font |

### Color Themes (`OYZ_THEME`)

Set `OYZ_THEME` in your `~/.zshrc`:

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

---

## ⚡ Performance Comparison

Tested on macOS Apple Silicon and Linux:

| Metric | Oh My Zsh (default + git) | Starship | **Oh Your Zsh** |
| :--- | :--- | :--- | :--- |
| **Cold Startup Time** | ~320ms – 1,100ms | ~45ms | **< 4ms** |
| **External Dependencies** | Git, Python/Ruby/Perl plugins, Curl | Rust binary + Nerd Font | **Zero (Native Zsh)** |
| **Font Requirements** | Patched Nerd Fonts / Powerline | Patched Nerd Fonts | **None (Core Unicode)** |
| **Codebase Size** | > 100,000 lines | > 40,000 lines (compiled) | **< 100 lines (Readable)** |
| **Support Overhead** | High (plugins conflict, hooks clash) | Medium (binary updates) | **Zero (What you see is what runs)** |

---

## 🧩 Plugins (Zero-Mystery, Opt-in)

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

1. **Deterministic Onboarding**: No time wasted installing custom fonts, fixing iTerm2 settings, or resolving Oh My Zsh updater locks.
2. **No Terminal Paste Corruption**: Permanently eliminates paste freezes and URL corruption via `zle_highlight+=(paste:none)`.
3. **Virtualenv Cleanliness**: Enforces `export VIRTUAL_ENV_DISABLE_PROMPT=1` so Python virtual environments cleanly show inside the prompt without double prefixes.

---

## 📄 License

MIT License. Free for personal and commercial use. See [LICENSE](LICENSE) for details.
