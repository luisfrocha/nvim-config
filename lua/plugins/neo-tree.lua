return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    {
      "<leader>e",
      ":Neotree toggle reveal_force_cwd<cr>",
      desc = "Explorer NeoTree (root dir)",
    },
  },
  config = function()
    require("neo-tree").setup({
      reveal_force_cwd = true,
      popup_border_style = "rounded",
      sort_case_insensitive = true,
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        sources = {
          { source = "filesystem", display_name = " 󰉓 Files " },
          { source = "git_status", display_name = " 󰊢 Git " },
          { source = "buffers", display_name = "  Buffers " },
        },
      },
      sort_function = function(a, b)
        return a.path:lower() < b.path:lower()
      end,
      window = {
        position = "float",
        popup = {
          size = {
            height = "90%",
            width = "90%",
          },
          winblend = 40,
        },
      },
      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          force_visible_in_empty_folder = true, -- when true, hidden files will be shown if the root folder is otherwise empty
          hide_dotfiles = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_name = {
            "node_modules",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            ".DS_Store",
            "thumbs.db",
            ".git",
          },
        },
        follow_current_file = { enabled = true },
      },
    })
  end,
}
