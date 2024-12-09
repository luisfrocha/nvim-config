return {
  'neovim/nvim-lspconfig',
  dependencies={'yioneko/nvim-vtsls'},
  config = function()
    local lspconfig = require('lspconfig')
    require('lspconfig.configs').vtsls = require('vtsls').lspconfig
    lspconfig.vtsls.setup({})

    -- Set global defaults for all servers
    lspconfig.util.default_config = vim.tbl_extend(
      'force',
      lspconfig.util.default_config,
      {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          -- returns configured operations if setup() was already called
          -- or default operations if not
          require('lsp-file-operations').default_capabilities()
        )
      }
    ) 

    vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
      local locations = command.arguments[3]
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if locations and #locations > 0 then
        local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
        vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
        vim.api.nvim_command("lopen")
      end
    end
  end,
  opts = {
    servers = { eslint = {}},
    settings = {
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        }
      },
    }
  }
}
