vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup()

local mason_config = require("mason-config")

require("mason-lspconfig").setup({
	automatic_enable = {
		exclude = mason_config.automatic_enable_exclude,
	},
})

require("mason-tool-installer").setup({
	ensure_installed = mason_config.ensure_installed,
	auto_update = true,
	run_on_start = true,
	debounce_hours = 1,
})
