return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
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
      "tsserver",
      "volar",
      "yamlls",
    },
    automatic_installation = true,
  },
  enabled = false,
  event = "BufReadPre",
  dependencies = "mason-org/mason.nvim",
  config = function()
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          if require("neoconf").get(server_name .. ".disable") then
            return
          end
          if server_name == "volar" then
            server.filetypes = { "vue", "typescript", "javascript" }
          end
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
