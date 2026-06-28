vim.pack.add({ {
  src = "https://github.com/mrcjkb/rustaceanvim",
} })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.keymap.set("n", "<leader>f", function()
      vim.cmd.RustLsp("codeAction")
    end, { buffer = bufnr })

    vim.keymap.set("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, { buffer = bufnr })

    vim.keymap.set("n", "<leader>dj", function()
      vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
    end, { buffer = bufnr })
    vim.keymap.set("n", "<leader>dk", function()
      vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
    end, { buffer = bufnr })
  end,
})
