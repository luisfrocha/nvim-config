return {
  "napmn/react-extract.nvim",
  keys = {
    {
      "<leader>re",
      function()
        require("react-extract").extract_to_new_file()
      end,
      desc = "Extract to New File",
      mode = "v",
    },
    {
      "<leader>rc",
      function()
        require("react-extract").extract_to_current_file()
      end,
      desc = "Extract to Current File",
      mode = "v",
    },
  },
}
