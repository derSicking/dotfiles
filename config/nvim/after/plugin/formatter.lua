require("formatter").setup({
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
			require("formatter.filetypes.javascript").eslint_d,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
			require("formatter.filetypes.typescript").eslint_d,
		},
		html = {
			require("formatter.filetypes.html").prettier,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})
