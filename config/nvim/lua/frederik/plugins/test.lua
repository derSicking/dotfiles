---@diagnostic disable: missing-fields
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"rcasia/neotest-java",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-java")({}),
				},
			})
		end,
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
			},
			{
				"<leader>td",
				function()
					if vim.bo.filetype == "java" then
						require("jdtls.dap").test_nearest_method()
					else
						require("neotest").run.run({ strategy = "dap" })
					end
				end,
			},
			{
				"<leader>tD",
				function()
					if vim.bo.filetype == "java" then
						require("jdtls.dap").test_class()
					else
						require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
					end
				end,
			},
			{
				"<leader>ts",
				function()
					require("neotest").run.stop({ interactive = true })
				end,
			},
			{
				"<leader>tgo",
				function()
					require("neotest").output.open({ enter = true, last_run = true })
				end,
			},
			{
				"<leader>tgs",
				function()
					require("neotest").summary.toggle()
				end,
			},
			{
				"<leader>tgp",
				function()
					require("neotest").output_panel.toggle()
				end,
			},
		},
	},
}
