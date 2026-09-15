return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        ignore_whitespace = true,
        virt_text_pos = "eol",
      },
      current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> • <summary>",
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History (Diffview)" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open({ kind = "tab" })
        end,
        desc = "Neogit (Root Dir)",
      },
    },
    opts = {
      disable_insert_on_commit = "auto",
      integrations = {
        diffview = true,
      },
      kind = "tab",
      commit_editor = {
        kind = "tab",
        show_staged_diff = true,
        spell_check = true,
        staged_diff_split_kind = "split",
      },
    },
  },
}
