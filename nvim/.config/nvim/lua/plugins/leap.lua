return {
  {
    "https://codeberg.org/andyg/leap.nvim.git",
    name = "leap.nvim",
    config = function()
      vim.keymap.set("n", "s", function()
        require("leap").leap({
          target_windows = { vim.api.nvim_get_current_win() },
        })
      end, { desc = "Leap" })
    end,
  },
}
