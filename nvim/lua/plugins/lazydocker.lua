-- LazyDocker in a floating terminal (via snacks.nvim, already bundled with LazyVim).
-- Mirrors how LazyVim opens lazygit with <leader>gg.
--
-- DOCKER_HOST is pinned to the Apple `container` compat VM socket so lazydocker
-- always targets the dev stack regardless of the active docker context. Remove
-- the `env` block to instead follow whatever `docker context` is current.
return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>cd",
      function()
        Snacks.terminal.toggle("lazydocker", {
          env = { DOCKER_HOST = "unix://" .. vim.env.HOME .. "/.config/container/compat/compat.sock" },
          win = { style = "lazygit", title = " lazydocker " },
        })
      end,
      desc = "LazyDocker (compat containers)",
    },
  },
}
