return {
  {
    {
      "vuki656/package-info.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
      opts = {
        package_manager = "pnpm",
        autostart = true,
        icons = {
          enable = true,
        },
      },
      keys = {
        {
          "<leader>ps",
          function()
            require("package-info").show()
          end,
          desc = "Show dependency version",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>pc",
          function()
            require("package-info").hide()
          end,
          desc = "Hide dependency versions",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>pt",
          function()
            require("package-info").toggle()
          end,
          desc = "Toggle dependency versions",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>pu",
          function()
            require("package-info").update()
          end,
          desc = "Update dependency on the line",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>pd",
          function()
            require("package-info").delete()
          end,
          desc = "Delete dependency on the line",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>pi",
          function()
            require("package-info").install()
          end,
          desc = "Install a new dependency",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>pp",
          function()
            require("package-info").change_version()
          end,
          desc = "Install a different dependency version",
          mode = "n",
          silent = true,
          noremap = true,
        },
      },
    },
  },
}
