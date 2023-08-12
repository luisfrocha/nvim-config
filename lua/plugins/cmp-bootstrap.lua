return {
  {
    "rambhosale/cmp-bootstrap.nvim",
    after = "nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")

      cmp.setup.filetype("html", {
        sources = cmp.config.sources({
          { name = "cmp_bootstrap" },
          -- other sources
        }),
      })
    end,
  },
}
