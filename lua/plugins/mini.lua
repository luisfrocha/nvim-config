return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.ai').setup()
    -- require('mini.animate').setup()
    require('mini.basics').setup()
    require('mini.bracketed').setup()
    require('mini.bufremove').setup()
    require('mini.comment').setup()
    require('mini.completion').setup()
    require('mini.cursorword').setup()
    require('mini.deps').setup()
    -- require('mini.diff').setup()
    require('mini.extra').setup()
    -- require('mini.files').setup()
    require('mini.fuzzy').setup()
    require('mini.hipatterns').setup()
    require('mini.icons').setup()
    -- require('mini.indentscope').setup()
    -- require('mini.map').setup()
    require('mini.move').setup({
      mappings = {
        left = '<C-S-h>',
        right = '<C-S-l>',
        down = '<C-S-j>',
        up = '<C-S-k>',

        line_left = '<C-S-h>',
        line_right = '<C-S-l>',
        line_down = '<C-S-j>',
        line_up = '<C-S-k>',
      }
    })
    require('mini.notify').setup()
    require('mini.pairs').setup()
    -- require('mini.sessions').setup()
    -- require('mini.statusline').setup()
    require('mini.surround').setup()
  end
}
