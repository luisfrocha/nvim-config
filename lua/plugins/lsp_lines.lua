return {
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
    require('lsp_lines').setup()
  end,
  init = function()
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = { only_current_line = true }
    })
  end,
  keys = {
    {'<leader>ll',":lua require('lsp_lines').toggle()<cr>",{desc='Toggle lsp_lines'}}
  }
}
