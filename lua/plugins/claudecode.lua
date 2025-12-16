local toggle_key = "<C-,>"
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      ---@module "snacks"
      ---@type snacks.win.Config|{}
      snacks_win_opts = {
        relative = "editor",
        position = "bottom", -- ✅ bottom drawer
        row = 0.65,
        col = 0.5,
        height = 100,
        max_height = 20,
        width = 0, -- ✅ full width
        border = "rounded",
        title = " Claude ",
        backdrop = 0,
        stack = true,
        resize = true,
        enter = true,
        keys = {
          claude_hide = {
            toggle_key,
            function(self)
              self:hide()
            end,
            mode = "t",
            desc = "Hide",
          },
        },
      },
    },
    terminal_cmd = "~/.nvm/versions/node/v24.4.1/bin/claude", -- Use output from 'which claude'
    -- terminal = {
    --   ---@module "snacks"
    --   ---@type snacks.win.Config|{}
    --   snacks_win_opts = {
    --     position = "float",
    --     backdrop = 50,
    --     stack = true,
    --     resize = true,
    --     enter = true,
    --     max_height = 0.5,
    --     border = "rounded",
    --     title = "Claude",
    --     keys = {
    --       claude_hide = {
    --         toggle_key,
    --         function(self)
    --           self:hide()
    --         end,
    --         mode = "t",
    --         desc = "Hide",
    --       },
    --     },
    --   },
    -- },
  },
  -- config = function()
  --   require("claudecode").setup({
  --     window = {
  --       position = "bottom",
  --       height = 15,
  --     },
  --     diff = {
  --       enabled = true,
  --     },
  -- })
  --
  -- local function close_claude_diff_buffers()
  --   vim.defer_fn(function()
  --     for _, win in ipairs(vim.api.nvim_list_wins()) do
  --       local buf = vim.api.nvim_win_get_buf(win)
  --       local ft = vim.bo[buf].filetype
  --       local bt = vim.bo[buf].buftype
  --       local name = vim.api.nvim_buf_get_name(buf)
  --
  --       if ft == "diff" or bt == "nofile" or name:match("fugitive") or name:match("claude") then
  --         pcall(vim.api.nvim_win_close, win, true)
  --       end
  --     end
  --   end, 150)
  -- end
  --
  --   vim.keymap.set("n", "<leader>ca", function()
  --     require("claudecode").accept()
  --     close_claude_diff_buffers()
  --   end, { desc = "Claude Accept + Close Diffs" })
  --
  --   vim.api.nvim_create_autocmd("WinEnter", {
  --     callback = function()
  --       if vim.bo.filetype == "diff" and vim.fn.winnr("$") > 2 then
  --         vim.cmd("close")
  --       end
  --     end,
  --   })
  -- end,
  keys = {
    { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
  },
}
