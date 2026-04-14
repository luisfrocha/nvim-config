# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal Neovim configuration built on [LazyVim](https://www.lazyvim.org/). Uses `lazy.nvim` as the plugin manager and extends LazyVim defaults with custom plugins, keymaps, and settings.

## Tech Stack

- **Base**: LazyVim (LazyVim/LazyVim)
- **Plugin Manager**: lazy.nvim
- **Language**: Lua
- **Formatter**: StyLua (see `stylua.toml`)
- **GUI support**: Neovide

## Project Structure

### Key Directories and Files

- **`init.lua`**: Entry point — bootstraps lazy.nvim, sets transparent background, Neovide-specific config
- **`lua/config/`**: Core configuration
  - `lazy.lua`: Plugin manager setup and spec imports
  - `keymaps.lua`: Custom key mappings
  - `options.lua`: Vim options and global settings
  - `autocmds.lua`: Autocommands
  - `icons.lua`: Icon definitions
- **`lua/plugins/`**: Individual plugin config files (one file per plugin or feature group)
  - `conform.lua`: Formatting (conform.nvim)
  - `nvim-lspconfig.lua`: LSP server configuration
  - `nvim-lint.lua`: Linting setup
  - `mason.lua`: Mason tool installer config
  - `elixir.lua`: Elixir-specific tooling
  - `fzf-lua.lua`: Fuzzy finder
  - `grug-far.lua`: Search and replace
  - `claudecode.lua`: Claude Code integration
  - `colorscheme.lua`, `oldworld.lua`: Themes
  - `lualine.lua`, `bufferline.lua`, `dropbar.lua`: UI/statusline
  - `neo-tree.lua`: File explorer
  - `nvim-treesitter.lua`: Treesitter config
  - `nvim-cmp.lua`: Completion
  - `neotest-elixir.lua`: Elixir test runner
  - `productivity.lua`, `advanced.lua`: Misc productivity plugins
- **`stylua.toml`**: StyLua formatting config (used to format all Lua files)
- **`lazyvim.json`**: LazyVim extras enabled
- **`lazy-lock.json`**: Plugin version lockfile (do not manually edit)

## Adding Plugins

1. Create a new file in `lua/plugins/your-plugin.lua`
2. Return a table (or array of tables) following the lazy.nvim spec:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy", -- or "BufEnter", "InsertEnter", etc.
  opts = {
    -- plugin options
  },
  config = function(_, opts)
    require("plugin-name").setup(opts)
  end,
}
```

3. To override a LazyVim default plugin, use the same plugin name — lazy.nvim merges specs.

## Keymaps

Custom keymaps are in `lua/config/keymaps.lua`. Key conventions:

- Leader key: `<Space>`
- `jk` → Exit insert mode
- `H` / `L` → Start / end of line
- `<C-s>` → Save all
- `<C-d>` → Copy line down
- `<C-S-F>` → Global search (grug-far)
- `<C-F>` → Search in current file (grug-far)
- `<C-Tab>` → Open buffer picker (FzfLua)

## Code Style

All Lua files are formatted with **StyLua**. Run before committing:

```bash
stylua lua/
```

Configuration is in `stylua.toml`.

## CLAUDE.md Maintenance

- **Propagating updates**: When a rule or guideline is added or changed in an individual project's CLAUDE.md — whether it's already generic or could be made generic — generalize it if needed, add or update it in `~/.claude/CLAUDE.md`, and then disseminate to all other project CLAUDE.md files (with any project-specific values like commands filled in per project).
- **Command lookup**: Always use the test and lint commands specified in the current project's CLAUDE.md. Never guess or use a default — if the project's CLAUDE.md defines `mix test`, use `mix test`; if it defines `npm test`, use `npm test`, etc.

## Commit & PR Workflow

When the user asks to "commit" changes or "create a PR", this means the full workflow:
1. Review the staged/changed files
2. Run `stylua lua/` to format all Lua files and re-stage
3. Create a commit message and commit

Note: This is a Neovim config — there are no automated tests to run.

When providing a commit message:
1. Subject line has no bullet point
2. Each description item starts with "- " (dash and space)
3. Each description item is a single line (no line breaks within an item)
4. Only include changes from currently staged files
5. No spaces at beginning of lines (either subject or description)
6. Always copy the commit message to the macOS clipboard using: `cat << 'EOF' | pbcopy ... EOF` — unless Claude is the one executing the commit, in which case copying to the clipboard is not needed

## Git Workflow

- **Main branch**: `main`
- **Current branch**: `lazyvim-update`
- No pre-commit hooks — format manually with StyLua before committing
