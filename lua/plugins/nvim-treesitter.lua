return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "angular", "scss", "vue", "css", "dockerfile", "elixir", "heex", "eex" })
    end
    vim.treesitter.language.register("markdown", "livebook")
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      pattern = { "*.component.html", "*.container.html" },
      callback = function()
        vim.treesitter.start(nil, "angular")
      end,
    })
  end,
}
