-- dev.lua — full-stack dev layer (TS/Go/Rust/Python), lazy-loaded
-- Language LSP/DAP/test adapters come from LazyVim extras; keep only
-- tools and parsers those extras do not provide.
return {
  -- Treesitter: extend extras instead of overwriting their parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
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
      })
    end,
  },

  -- Mason: ensure only binaries not covered by language extras
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "prettier",
        "dockerfile-language-server",
        "yaml-language-server",
        "stylua",
        "lua-language-server",
        -- rustaceanvim expects an external binary; the Rust extra only ensures codelldb
        "rust-analyzer",
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
}
