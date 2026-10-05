-- Work computer only: the repo lives on Apple's internal GitHub
return {
  "nexus.nvim",
  url = "git@github.pie.apple.com:AI-for-Devs-Community/nexus.nvim.git",
  enabled = function()
    return vim.fn.system({ "git", "config", "--global", "user.email" }):match("^lf_rocha@") ~= nil
  end,
  -- branch = "dev", -- if you want use use the dev branch, upcoming features
  -- tag = "v2.0.0-beta", -- if you want use a specifically tagged version
  event = "VeryLazy",
  config = function()
    -- The default codelm provider authenticates via DAW, which AppleConnect no longer supports
    require("nexus").setup({ provider = { name = "genai" } })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
