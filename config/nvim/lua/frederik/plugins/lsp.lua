local config = require("frederik.lsp")

return {
	{ "folke/neodev.nvim", lazy = false, priority = 103, opts = {} },
	{ "williamboman/mason.nvim", lazy = false, priority = 102, opts = {} },
	{ "williamboman/mason-lspconfig.nvim", lazy = false, priority = 101, opts = { handlers = config.handlers } },
	{ "neovim/nvim-lspconfig", lazy = false, priority = 100 },
	{
		"WhoIsSethDaniel/mason-tool-installer",
		lazy = false,
		priority = 99,
		opts = {
			ensure_installed = config.ensure_installed,
			auto_update = true,
			run_on_start = true,
			debounce_hours = 1,
		},
	},
	{
		"smjonas/inc-rename.nvim",
		lazy = true,
		opts = {},
		keys = {
			{ "<leader>rn", ":IncRename " },
		},
	},
	{
		"aznhe21/actions-preview.nvim",
		lazy = true,
		keys = {
			{ "<leader>f", require("actions-preview").code_actions, mode = { "n", "v" } },
		},
	},
}
