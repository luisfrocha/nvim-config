-- Enhancements to LazyVim's default Elixir extra
return {
  -- Add vim-elixir for syntax highlighting
  -- (LazyVim's default elixir extra doesn't include this)
  {
    "elixir-editors/vim-elixir",
    ft = { "elixir", "heex", "eex", "exs" },
    lazy = false, -- Load immediately to ensure syntax highlighting works
    enabled = false,
  },
}
