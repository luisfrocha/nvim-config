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

## Commit Message Guidelines

When the user asks to "commit" changes:

1. Review staged changes
2. Write a concise commit message:
   - Subject line: no bullet point, imperative mood
   - Description items start with `- ` (dash and space), one line each
   - Only include changes from currently staged files
   - No leading spaces
3. Copy the commit message to clipboard: `cat << 'EOF' | pbcopy ... EOF` — unless Claude is executing the commit directly, in which case clipboard copy is not needed

## Git Workflow

- **Main branch**: `main`
- **Current branch**: `lazyvim-update`
- No pre-commit hooks — format manually with StyLua before committing
