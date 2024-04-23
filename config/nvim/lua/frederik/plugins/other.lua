return {
	"rgroli/other.nvim",
	name = "other-nvim",
	opts = {
		mappings = { "angular" },
		rememberBuffers = false,
		style = {
			border = "solid",
			seperator = "|",
		},
	},
	cmd = "Other",
	keys = {
		{ "<leader>po", "<cmd>Other<cr>" },
	},
}
