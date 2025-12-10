return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    -- require("nvim-treesitter.install").compilers = { "gcc", "clang" }
    require("nvim-treesitter.install").prefer_git = false
  end,
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        -- Web technologies
        "scss",
        "css",
        "html",
        "vue",
        "typescript",
        "tsx",
        "javascript",
        "jsx",

        -- Elixir ecosystem
        "elixir",
        "heex",
        "eex",

        -- Other
        "dockerfile",
        "json",
        "yaml",
        "markdown",
      })
    end

    -- Register livebook files as markdown
    vim.treesitter.language.register("markdown", "livebook")

    -- Enhanced highlighting configuration
    opts.highlight = opts.highlight or {}
    opts.highlight.enable = true
    opts.highlight.additional_vim_regex_highlighting = { "elixir" }

    -- Better incremental selection
    opts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    }

    -- Enhanced text objects
    opts.textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    }
  end,
}
