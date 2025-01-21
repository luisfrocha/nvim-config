local opts = {
  ensure_installed = {
    "cssls",
    "cssmodules_ls",
    "emmet_ls",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "sqlls",
    "tailwindcss",
    -- "tsserver",
    "volar",
    "yamlls",
  },
  automatic_installation = true,
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  event = "BufReadPre",
  dependencies = "williamboman/mason.nvim",
}
