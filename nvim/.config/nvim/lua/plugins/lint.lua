return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint"] = {
          args = { "--disable", "MD013", "--" },
        },
        ["markdownlint-cli2"] = {
          args = { "--disable", "MD013", "--" },
        },
      },
    },
  },
}
