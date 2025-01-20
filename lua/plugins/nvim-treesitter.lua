return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "scss", "vue", "css", "dockerfile", "elixir", "heex", "eex" })
    end
    vim.treesitter.language.register("markdown", "livebook")
  end,
}
