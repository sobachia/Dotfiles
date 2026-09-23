return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<C-S-B>",
        function()
          vim.cmd("write")

          local file = vim.fn.expand("%:p")
          local output = vim.fn.expand("%:p:r")

          local cmd = string.format("g++ -std=c++17 -Wall -Wextra -g %q -o %q && %q", file, output, output)

          Snacks.terminal.open(cmd, {
            win = {
              position = "bottom",
              height = 12,
            },
          })
        end,
        desc = "C++ Compile & Run",
        ft = "cpp",
      },
    },
  },
}
