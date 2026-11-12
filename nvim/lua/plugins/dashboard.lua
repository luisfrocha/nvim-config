-- Adds a "Mason" entry (hotkey "m") to the snacks dashboard, right after "Lazy".
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    local keys = vim.tbl_get(opts, "dashboard", "preset", "keys")
    if not keys then
      return
    end
    for i, item in ipairs(keys) do
      if item.key == "l" then
        table.insert(keys, i + 1, { icon = "\u{f0ad} ", key = "m", desc = "Mason", action = ":Mason" })
        break
      end
    end
  end,
}
