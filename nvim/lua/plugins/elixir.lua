-- Enhancements to LazyVim's default Elixir extra
return {
  -- Add vim-elixir for syntax highlighting
  -- (LazyVim's default elixir extra doesn't include this)
  {
    "elixir-editors/vim-elixir",
    ft = { "elixir", "exs" },
    lazy = false, -- Load immediately to ensure syntax highlighting works
    config = function()
      vim.filetype.add({ extension = { heex = "heex" } })
    end,
  },
}
