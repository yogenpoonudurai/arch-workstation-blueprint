return {
  -- gopher.nvim: Go tooling (struct tags, test gen, etc.)
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = function()
      vim.cmd("silent! GoInstallDeps")
    end,
    opts = {},
    keys = {
      { "<leader>cgj", "<cmd>GoTagAdd json<cr>", desc = "Add JSON struct tags" },
      { "<leader>cgy", "<cmd>GoTagAdd yaml<cr>", desc = "Add YAML struct tags" },
      { "<leader>cgr", "<cmd>GoTagRm<cr>", desc = "Remove struct tags" },
    },
  },
}
