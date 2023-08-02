return {
  "xiyaowong/transparent.nvim",
  cond = false,
  config = function()
    vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
    require("transparent").setup({
      extra_groups = {
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeExpander",
        "NeoTreeIndentMarker",
        "NormalFloat",
        "NvimTreeNormal",
      },
    })
  end,
}
