return {
  "kristijanhusak/vim-js-file-import",
  dependencies = {
    "ludovicchabant/vim-gutentags",
  },
  config = function()
    vim.fn.system("npm install")
  end,
}
