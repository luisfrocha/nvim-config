return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = { defaults = { mode = { "n", "v" }, ["<leader>p"] = { name = "Package Manager" } } },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
