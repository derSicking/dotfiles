local lsp_lines_enabled = false

return {
	{ "folke/neodev.nvim", lazy = false, priority = 103, opts = {} },
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
			{
				"<leader>f",
				function()
					require("actions-preview").code_actions()
				end,
				mode = { "n", "v" },
			},
		},
	},
	{
		"maan2003/lsp_lines.nvim",
		opts = {},
		keys = {
			{
				"<leader>dl",
				function()
					lsp_lines_enabled = not lsp_lines_enabled
					vim.diagnostic.config({ virtual_lines = lsp_lines_enabled, virtual_text = not lsp_lines_enabled })
				end,
			},
		},
	},
}
