-- dev.lua — fast full-stack dev layer (TS/Go/Rust/Python), lazy-loaded
-- Kept lean: DAP + tests load on keys only, no startup cost.
return {
  -- Treesitter: ensure only what we use
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "typescript",
        "tsx",
        "javascript",
        "go",
        "rust",
        "python",
        "lua",
        "bash",
        "json",
        "yaml",
        "toml",
        "dockerfile",
        "markdown",
      },
    },
  },

  -- Mason: ensure LSP/DAP binaries (installs on demand, no blocking)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "vtsls",
        "eslint-lsp",
        "prettier",
        "gopls",
        "delve",
        "rust-analyzer",
        "pyright",
        "ruff",
        "dockerfile-language-server",
        "yaml-language-server",
        "stylua",
        "lua-language-server",
      },
    },
  },

  -- Faster Lua dev on this repo (hypr lua + nvim config)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- DAP UI loads on debug keys only
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
    },
  },

  -- Tests load on keys only
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
    },
    dependencies = {
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {},
        ["neotest-python"] = {},
        ["neotest-rust"] = {},
      },
    },
  },
}
