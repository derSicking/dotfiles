return {
	"folke/trouble.nvim",
	keys = {
		{
			"<leader>dt",
			"<cmd>Trouble diagnostics toggle<cr>",
		},
		{
			"<leader>dT",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		},
		{
			"<leader>is",
			"<cmd>Trouble symbols toggle focus=false<cr>",
		},
		{
			"<leader>il",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		},
	},
	opts = {},
}
