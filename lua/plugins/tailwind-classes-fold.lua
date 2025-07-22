return {
  "wwnbb/tailwind-classes-fold",
  config = function()
    local tcf = require("tailwind-classes-fold")
    tcf.setup()
    vim.keymap.set("n", "zt", function()
      tcf.toggle_conceal()
    end, { desc = "Toggle Tailwind Class Fold" })
  end,
}
