return {
  {
    {
      "vuki656/package-info.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      opts = {
        package_manager = "pnpm",
      },
      keys = {
        {
          "<leader>ns",
          function()
            require("package-info").show()
          end,
          desc = "Show dependency version",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>nc",
          function()
            require("package-info").hide()
          end,
          desc = "Hide dependency versions",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>nt",
          function()
            require("package-info").toggle()
          end,
          desc = "Toggle dependency versions",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>nu",
          function()
            require("package-info").update()
          end,
          desc = "Update dependency on the line",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>nd",
          function()
            require("package-info").delete()
          end,
          desc = "Delete dependency on the line",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>ni",
          function()
            require("package-info").install()
          end,
          desc = "Install a new dependency",
          mode = "n",
          silent = true,
          noremap = true,
        },
        {
          "<leader>np",
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
