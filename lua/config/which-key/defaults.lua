return {
  {
    "<leader>f",
    function()
      require("config.utils").telescope_git_or_file()
    end,
    desc = "Find Files (Root)",
  },
}
