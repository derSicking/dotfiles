vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup()

require("mason-lspconfig").setup({
	automatic_enable = {
		exclude = require("mason-config").automatic_enable_exclude,
	},
})

require("mason-tool-installer").setup({
	ensure_installed = require("mason-config").ensure_installed,
	auto_update = true,
	run_on_start = true,
	debounce_hours = 1,
})
