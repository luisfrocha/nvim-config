return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      init = function()
        -- disable rtp plugin, as we only need its queries for mini.ai
        -- In case other textobject modules are enabled, we will load them
        -- once nvim-treesitter is loaded
        require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        load_textobjects = true
      end,
    },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
  },
  cmd = { "TSUpdateSync" },
  keys = {
    { "<c-space>", desc = "Increment selection" },
    { "<bs>", desc = "Decrement selection", mode = "x" },
  },
  config = function()
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
  end,
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "astro",
      "css",
      "glimmer",
      "graphql",
      "html",
      "javascript",
      "lua",
      "nix",
      "php",
      "python",
      "scss",
      "svelte",
      "tsx",
      "twig",
      "typescript",
      "vim",
      "vue",
    })
  end,
}
