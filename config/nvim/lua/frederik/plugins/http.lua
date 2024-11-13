return {
	"mistweaverco/kulala.nvim",
	keys = {
		{
			"<leader>tr",
			function()
				require("kulala").run()
			end,
		},
	},
}
