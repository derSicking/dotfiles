return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	opts = {
		scope = "git",
		icons = true,
		status = true,
	},
	cmd = "Grapple",
	keys = {
		{ "<leader>a", "<cmd>Grapple toggle<cr>" },
		{ "<c-e>", "<cmd>Grapple toggle_tags<cr>" },

		{ "<leader>1", "<cmd>Grapple select index=1<cr>" },
		{ "<leader>2", "<cmd>Grapple select index=2<cr>" },
		{ "<leader>3", "<cmd>Grapple select index=3<cr>" },
		{ "<leader>4", "<cmd>Grapple select index=4<cr>" },
		{ "<leader>5", "<cmd>Grapple select index=5<cr>" },
		{ "<leader>6", "<cmd>Grapple select index=6<cr>" },
		{ "<leader>7", "<cmd>Grapple select index=7<cr>" },
		{ "<leader>8", "<cmd>Grapple select index=8<cr>" },
		{ "<leader>9", "<cmd>Grapple select index=9<cr>" },
		{ "<leader>0", "<cmd>Grapple select index=10<cr>" },
		{
			"<leader>G",
			function()
				vim.print(require("grapple").tags())
			end,
		},
	},
}
