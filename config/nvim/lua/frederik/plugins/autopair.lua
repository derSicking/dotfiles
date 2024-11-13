return {
	{
		"altermo/ultimate-autopair.nvim",
		-- branch = "v0.6",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {
			opts = {
				enable_close_on_slash = true,
			},
		},
	},
	{
		"andymass/vim-matchup",
		init = function()
			vim.g.matchup_surround_enabled = 1
		end,
	},
}
