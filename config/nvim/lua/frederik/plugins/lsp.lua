return {
	{ "folke/lazydev.nvim", lazy = false, priority = 103, opts = {}, ft = "lua" },
	{ "williamboman/mason.nvim", lazy = false, priority = 102, opts = {} },
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		priority = 101,
		config = function()
			require("mason-lspconfig").setup({
				handlers = require("frederik.lsp").handlers,
			})
		end,
	},
	{ "neovim/nvim-lspconfig", lazy = false, priority = 100 },
	{
		"WhoIsSethDaniel/mason-tool-installer",
		lazy = false,
		priority = 99,
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = require("frederik.lsp").ensure_installed,
				auto_update = true,
				run_on_start = true,
				debounce_hours = 1,
			})
		end,
	},
}
