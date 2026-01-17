return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = { provider = "none" },
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
    },
  },
  keys = {
    { "<leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Diff" },
    { "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Diff" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add Buffer" },
    { "<leader>as", "<cmd>ClaudeCodeAdd<cr>", mode = "v", desc = "Add Selection" },
  },
  event = "VeryLazy",
}
