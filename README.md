# nvim-config

Personal Neovim + Ghostty configuration.

- **`nvim/`** — Neovim config built on [LazyVim](https://github.com/LazyVim/LazyVim), symlinked to `~/.config/nvim`
- **`ghostty/`** — Ghostty terminal config, symlinked to `~/.config/ghostty`
- **`bin/`** — personal scripts, symlinked into `~/.local/bin`
- **`claude/skills/`** — Claude Code skills, symlinked into `~/.claude/skills`

Run `./setup.sh --install` (`-i`) to set up symlinks on a new machine,
`./setup.sh --update` (`-u`) to pull and re-link, or `./setup.sh --uninstall`
(`-x`) to remove them. `./setup.sh --help` (`-h`) lists the options.
