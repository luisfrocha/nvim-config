return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_session_enabled = false,
      auto_session_enable_last_session = false,
      auto_session_suppress_dirs = { "~/", "~/Dev", "~/Downloads", "~/Documents", "~/Desktop/" },
      post_restore_cmds = function()
        local buffer_list = vim.fn.execute("ls t")
        local buf_names = vim.split(buffer_list, "\n")
        if #buf_names == 0 then
          vim.cmd([[Alpha]])
        end
      end,
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
  end,
}
