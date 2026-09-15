local excluded_test_directories = {
  ".git",
  ".next",
  "coverage",
  "dist",
  "node_modules",
}

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {
          filter_dir = function(name)
            return not vim.tbl_contains(excluded_test_directories, name)
          end,
        },
      },
    },
  },
}
