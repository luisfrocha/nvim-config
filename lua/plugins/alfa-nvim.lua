return {
  "goolord/alpha-nvim",
  enabled = true,
  event = "VimEnter",
  lazy = true,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = {
      [[ ███       ███ ]],
      [[████      ████]],
      [[██████     █████]],
      [[███████    █████]],
      [[████████   █████]],
      [[█████████  █████]],
      [[█████ ████ █████]],
      [[█████  █████████]],
      [[█████   ████████]],
      [[█████    ███████]],
      [[█████     ██████]],
      [[████      ████]],
      [[ ███       ███ ]],
      [[                  ]],
      [[ N  E  O  V  I  M ]],
    }
    --     local logo = [[
    -- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    -- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    -- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    -- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    -- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    -- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    --     ]]

    -- local logo = [[
    --                                                 
    --          ████ ██████           █████      ██
    --         ███████████             █████ 
    --         █████████ ███████████████████ ███   ███████████
    --        █████████  ███    █████████████ █████ ██████████████
    --       █████████ ██████████ █████████ █████ █████ ████ █████
    --     ███████████ ███    ███ █████████ █████ █████ ████ █████
    --    ██████  █████████████████████ ████ █████ █████ ████ ██████
    -- ]]

    dashboard.section.header.val = logo
    -- dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("s", " " .. "Restore Session", '<cmd>lua require("persistence").load()<cr>'),
      dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/ <CR>"),
      dashboard.button("z", "󰒲 " .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    -- dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.header.opts.hl = {
      {
        { "AlphaNeovimLogoBlue", 0, 0 },
        { "AlphaNeovimLogoGreen", 1, 14 },
        { "AlphaNeovimLogoBlue", 23, 34 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 2 },
        { "AlphaNeovimLogoGreenFBlueB", 2, 4 },
        { "AlphaNeovimLogoGreen", 4, 19 },
        { "AlphaNeovimLogoBlue", 27, 40 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 4 },
        { "AlphaNeovimLogoGreenFBlueB", 4, 7 },
        { "AlphaNeovimLogoGreen", 7, 22 },
        { "AlphaNeovimLogoBlue", 29, 42 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 8 },
        { "AlphaNeovimLogoGreenFBlueB", 8, 10 },
        { "AlphaNeovimLogoGreen", 10, 25 },
        { "AlphaNeovimLogoBlue", 31, 44 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 10 },
        { "AlphaNeovimLogoGreenFBlueB", 10, 13 },
        { "AlphaNeovimLogoGreen", 13, 28 },
        { "AlphaNeovimLogoBlue", 33, 46 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 14, 31 },
        { "AlphaNeovimLogoBlue", 35, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 16, 32 },
        { "AlphaNeovimLogoBlue", 35, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 17, 33 },
        { "AlphaNeovimLogoBlue", 35, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 18, 34 },
        { "AlphaNeovimLogoGreenFBlueB", 33, 35 },
        { "AlphaNeovimLogoBlue", 35, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 19, 35 },
        { "AlphaNeovimLogoGreenFBlueB", 34, 35 },
        { "AlphaNeovimLogoBlue", 35, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 20, 36 },
        { "AlphaNeovimLogoGreenFBlueB", 35, 37 },
        { "AlphaNeovimLogoBlue", 37, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 0, 13 },
        { "AlphaNeovimLogoGreen", 21, 37 },
        { "AlphaNeovimLogoGreenFBlueB", 36, 37 },
        { "AlphaNeovimLogoBlue", 37, 49 },
      },
      {
        { "AlphaNeovimLogoBlue", 1, 13 },
        { "AlphaNeovimLogoGreen", 20, 35 },
        { "AlphaNeovimLogoBlue", 37, 48 },
      },
      {},
      { { "AlphaNeovimLogoGreen", 0, 9 }, { "AlphaNeovimLogoBlue", 9, 18 } },
    }
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
